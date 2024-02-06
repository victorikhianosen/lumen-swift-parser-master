<?php

namespace App\Http\Controllers;

use App\Classes\Helpers;
use App\Exports\MessagesExport;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Maatwebsite\Excel\Facades\Excel;

class DownloadController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    private $excelData;
    private $file;
    public function __construct()
    {
        //
    }

    public function files(Request $request)
    {
        // Get files from database tab;e files or file storage
        try {
            return Storage::download($request->input('filename'));
        } catch (Exception $e) {
            return 'File not found';
        }

    }

    public function export(Request $request)
    {
        $helpers = new Helpers();
        $fileName = env('EXPORT_FILE_PREFIX') . '_' . date('YmdHis') . ".csv";
        // Add other columns headers here
        $fields = explode(",", "Reference Number,Header,Message Type,Sender,"
            . "Sender Account,Beneficiary,Beneficiary Account,Currency, Transaction Amount,"
            . "Transaction Date,Session Number,Sequence Number,IO Mode,Message Priority,Remittance Info,"
            . "Account Institution,Terminal Address,Message User Preference,Recipient BIC");
        $this->excelData[] = $fields;
        $query = DB::table('messages')->select('ref_number','header'
        , 'msg_type', 'sender' ,'sender_account', 'beneficiary', 'beneficiary_acct'
        , 'curr', 'tran_amount','tran_date','session_number', 'sequence_number'
        , 'io_mode','msg_priority','remittance_info','acct_inst','terminal_address'
        ,'msg_user_preference','recipient_bic');
        if ($request->has('msg_type') && $request->input('msg_type') !== '0') {
            $query->where('msg_type', $request->input('msg_type'));
        }
        if ($request->has('curr') && $request->input('curr') !== '0') {
            $query->where('curr', $request->input('curr'));
        }
        if ($request->has('io_mode') && $request->input('io_mode') !== '0') {
            $query->where('io_mode', $request->input('io_mode'));
        }
        // date must be on yyyy-mm-dd format
        if ($request->has('from') && $request->has('to')) {
            $query->whereBetween('tran_date', [$request->input('from'), $request->input('to')]);
        }
        $query->orderBy('created_at', 'desc')->chunk(100, function (Collection $messages) {
            foreach ($messages as $msg) {
                // double qoute some text
                //$lineData = json_decode(json_encode($msg), true);
                $lineData = (array) $msg;
                $this->excelData[] = $lineData;
               
            }
        });
        $export = new MessagesExport($this->excelData);
        return Excel::download($export, $fileName,\Maatwebsite\Excel\Excel::CSV);
    }

    public function report(Request $request)
    {

        $query = DB::table('messages')->select('id','ref_number','header'
            , 'msg_type', 'sender' ,'sender_account', 'beneficiary', 'beneficiary_acct'
            , 'curr', 'tran_amount','tran_date','session_number', 'sequence_number'
            , 'io_mode','msg_priority','remittance_info','acct_inst','terminal_address'
            ,'msg_user_preference','recipient_bic');
        if ($request->has('msg_type') && $request->input('msg_type') !== '0') {
            $query->where('msg_type', $request->input('msg_type'));
        }
        if ($request->has('curr') && $request->input('curr') !== '0') {
            $query->where('curr', $request->input('curr'));
        }
        if ($request->has('io_mode') && $request->input('io_mode') !== '0') {
            $query->where('io_mode', $request->input('io_mode'));
        }
        // date must be on yyyy-mm-dd format
        if ($request->has('from') && $request->has('to')) {
            $query->whereBetween('tran_date', [$request->input('from'), $request->input('to')]);
        }
        $query->orderBy('created_at', 'desc')->chunk(100, function (Collection $messages) {
            foreach ($messages as $msg) {
                // double qoute some text
                $lineData = (array) $msg;
                $this->excelData[] = $lineData;
            }
        });
        return response()->json(['items' => $this->excelData]);

    }

    public function get_message(Request $request)
    {

        $message = DB::table('messages')->where('id', $request->input('id'))->first();
        return response()->json($message);

    }

    //
}
