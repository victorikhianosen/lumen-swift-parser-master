<?php
namespace App\Classes;

use DateTime;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Lazzard\FtpClient\Config\FtpConfig;
use Lazzard\FtpClient\Connection\FtpConnection;
use Lazzard\FtpClient\FtpClient;
use Lazzard\FtpClient\FtpClientException;
use Lazzard\FtpClient\FtpWrapper;
use Log;
use Exception;

class ParserManager
{

    private $client;

    function __construct()
    {
        $connection = new FtpConnection(env('FTP_HOST'), env('FTP_USER'), env('FTP_PASSWORD'));
        $connection->open();
        $config = new FtpConfig($connection);
        $config->setPassive(true);
        $this->client = new FtpClient($connection);
    }
    function DownloadMsg($name)
    {

        if (DB::table('files')->where('filename', $name)->exists()) {
            echo "File: $name already processed..Skipping" . PHP_EOL;
            return;
        }
        try {
           
            $content = $this->client->getFileContent(env('FTP_DIR') . '/' . $name, FtpWrapper::ASCII);
            if($content){
                echo "File: $name processing contents..";
                Storage::disk('local')->put($name, $content);
                $this->registerFileInDb($name, $content);
                $this->MoveToProcessed($name);
                echo "Done" . PHP_EOL;
                return $content;
            }
           
        } catch (Exception $e) {
            $message = "File $name : Unable to process...Skipping (".$e->getMessage().")" . PHP_EOL;
            Log::info($message);
        }
        catch (FTPClientException $e) {
            $message = "FTPClientException $name : (".$e->getMessage().")" . PHP_EOL;
            Log::info($message);
        }

    }
    function saveExport($filename, $data)
    {
        Storage::disk('local')->put("exports/" . $name, $data);
    }

    function MoveToProcessed($name)
    {
        $src = env('FTP_DIR') . '/' . $name;
        $destination = env('FTP_DIR') . '/' . env('PROCESSED_DIR');
        try {
            $this->client->move($src, $destination);
        } catch (Exception $e) {
            Log::error($e->getMessage());
        }

    }

    function ListDir()
    {

        try {
            return $this->client->listDir(env("FTP_DIR"));

        } catch (Exception $e) {
            Log::error($e->getMessage());
        }

    }
    function saveMessage($info)
    {
        try {

            $tranAmount = empty($info['amt']) ? null : $info['amt']; //Assigns null to empty transaction amount

            //Converts Date
            $y = substr($info['datetime'], 0, 2);
            $m = substr($info['datetime'], 2, 2);
            $d = substr($info['datetime'], 4, 2);
            $date = new DateTime("$y-$m-$d");
            $formattedDate = $date->format('Y-m-d');

            DB::insert('INSERT INTO messages
            (doc_id, filename, ref_number, msg_type, io_mode, sender_account, sender, tran_amount, acct_inst, remittance_info, beneficiary, tran_timestamp, beneficiary_acct, curr, header, service_id,
            aok,terminal_address, session_number, recipient_bic, msg_priority, msg_user_preference, bank_priority_code, message_text, app_id, sequence_number, tran_date)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                [
                    $info['doc_id'],
                    $info['filename'],
                    $info['ref_number'],
                    $info['msg_type'],
                    $info['io_mode'],
                    $info['cust_accnt'],
                    $info['cust'],
                    $tranAmount,
                    $info['account_inst'],
                    $info['remittance_info'],
                    $info['beneficiary'],
                    $info['datetime'],
                    $info['beneficiary_account'],
                    $info['curr'],
                    $info['header'],
                    $info["ServiceId"],
                    $info["AOK"],
                    $info["TerminalAddress"],
                    $info["SessionNumber"],
                    $info["RecipientBIC"],
                    $info["MessagePriority"],
                    $info["MessageUserReference"],
                    $info["BankPriorityCode"],
                    "{".$info["Text"],
                    $info["ApplicationId"],
                    $info["SequenceNumber"],
                    $formattedDate,
                ]
            );

        } catch (\Exception $e) {
            Log::error($e->getMessage());
        }

    }
    function registerFileInDb($filename, $content)
    {
        try {
            DB::insert('insert into files (filename,file_content) values (?,?)', [$filename, $content]);
        } catch (Exception $e) {
            Log::error($e->getMessage());
        }

    }

}
