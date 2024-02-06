<?php # /app/Console/Commands/Parser.php
namespace App\Console\Commands;

use App\Classes\Helpers;
use App\Classes\ParserManager;
use Illuminate\Console\Command;
use Symfony\Component\Console\Input\InputOption;

class SwiftParser extends Command
{
    /**
     * The console command name.
     *
     * @var string
     */
    protected $name = 'swift:parse';
    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = "Parse swift files from ftp server";
    /**
     * Execute the console command.
     *
     * @return void
     */
    public function handle()
    {
        date_default_timezone_set("Africa/Lagos");
        set_time_limit(0);
        $helpers = new Helpers();
        $this->info("Initializing Parser Manager..");
        $mgr = new ParserManager();
        $files = $mgr->ListDir();

        if ($files) {
            $this->info("Processing files..");
            foreach ($files as $filename) {
                if ($filename !== env('PROCESSED_DIR')) {
                    $this->info("Fetching file $filename");

                    $contents = $mgr->DownloadMsg($filename);
                    if ($contents) {
                        $docs = explode('}${', $contents);
                        foreach ($docs as $id => $doc) {

                            $doc_id = "doc:" . $id;
                            $info['doc_id'] = "doc:" . $id;
                            $info['message_txt'] = $doc;
                            $info['filename'] = $filename;
                            $info['ref_number'] = $helpers->get_reference($doc);

                            // Save all all to $info and save to db
                            $info['text'] = $helpers->get_tag_value($doc, "{4:", "-}");
                            $info['msg_type'] = $helpers->get_message_type($doc);
                            $info['io_mode'] = $helpers->get_io_mode($doc);
                            $info['cust_accnt'] = $helpers->get_customer_account($doc);
                            $info['cust'] = $helpers->get_customer($doc);
                            
                            $info['account_inst'] = $helpers->get_account_institution($doc);
                            $info['remittance_info'] = $helpers->get_remittance_info($doc);
                            $info['beneficiary'] = $helpers->get_beneficiary($doc);
                            // you need to deal with formatting date specially, there are 2 columns to format, tran_date and tran_timestamp
                            $info['datetime'] = $helpers->get_datetime($doc);
                            $info['beneficiary_account'] = $helpers->get_beneficiary_account($doc);
                            $info['curr'] = $helpers->get_currency($doc);
                            $info['amt'] = $helpers->get_transaction_amount($doc);
                            $info['header'] = $helpers->get_header($doc);

                            $additional = $helpers->get_additional_info($doc);
                            $mgr->saveMessage(array_merge($info, $additional));

                        }
                    }

                }
            }
        }
       
        $this->info("Processing completed successfully");
    }
    /**
     * Get the console command options.
     *
     * @return array
     */
    protected function getOptions()
    {
        return array(
            array('host', null, InputOption::VALUE_OPTIONAL, 'The host address to serve the application on.', 'localhost'),
            array('port', null, InputOption::VALUE_OPTIONAL, 'The port to serve the application on.', 8000),
        );
    }
}
