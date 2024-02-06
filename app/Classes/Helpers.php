<?php 
namespace App\Classes;
use Illuminate\Support\Facades\Storage;
class Helpers
{


    function ExportCSV($array, $filename = "export.csv", $delimiter=",") {
    
        $handle = fopen(env("STORAGE_DIR")."/".env("APP_STORAGE_EXPORT_DIR")."/".$filename, "a");
        //$handle = fopen('php://output', 'w');
        // loop over the input array
        foreach ($array as $line) { 
            // generate csv lines from the inner arrays
            fputcsv($handle, $line, $delimiter); 
        }
        fclose($handle);
        $export_file = env("APP_STORAGE_EXPORT_DIR")."/".$filename;
        if (Storage::disk('local')->exists($export_file)) {
            return  Storage::download(env("APP_STORAGE_EXPORT_DIR")."/".$filename);
        }
    }

    function filterData(&$str){ 
        $str = preg_replace("/\t/", "\\t", $str); 
        $str = preg_replace("/\r?\n/", "\\n", $str); 
        if(strstr($str, '"')) $str = '"' . str_replace('"', '""', $str) . '"'; 
    }

    function get_additional_info($doc){
        $data['Text'] = $doc;
        $data["ServiceId"] = $this->get_service_id($doc);
        $data["Acknowledgment"] = $this->get_ack($doc);
        $data["ApplicationId"] = $this->get_app_id($doc);
        if (!str_contains($doc, "{1:F21")) {
            $data["TerminalAddress"] = substr($this->get_tag_value($doc, "1:F01"), 0, 12);
            $data["SessionNumber"] = substr($this->get_tag_value($doc, "1:F01"), -10, 4);
            $data["SequenceNumber"] = substr($this->get_tag_value($doc, "1:F01"), -6);
            $app = $this->get_tag_value($doc, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = $this->get_datetime($doc);
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $date['User'] = $this->get_tag_value($doc, "3:");
            $data["BankPriorityCode"] = $this->get_tag_value($doc, "113:");
            $data["MessageUserReference"] = $this->get_tag_value($doc, "108:");
            $data["AOK"] = $this->get_tag_value($doc, "433:");
           
        } else {
            $data["TerminalAddress"] = substr($this->get_tag_value($doc, "1:F01"), 0, 12);
            $data["SessionNumber"] = substr($this->get_tag_value($doc, "1:F01"), -10, 4);
            $data["SequenceNumber"] = substr($this->get_tag_value($doc, "1:F01"), -6);
            $app = $this->get_tag_value($doc, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = $this->get_datetime($doc);
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $data['User'] = $this->get_tag_value($doc, "3:");
            $data["BankPriorityCode"] = $this->get_tag_value($doc, "113:");
            $data["MessageUserReference"] = $this->get_tag_value($doc, "108:");
            $data["AOK"] = $this->get_tag_value($doc, "433:");
           
        }
        return $data;
    }

    function get_ack($doc)
    {

        return $this->get_tag_value($doc, "1:F01");
    }

    function get_header($doc)
    {

        return $this->string_between($doc, "1:F01", "}{");
    }

    function get_app_id($doc)
    {

        return substr($this->get_header($doc), 0, 1);
    }

    function get_service_id($doc)
    {

        $pos = strpos($doc, "F01");
        return ($pos === false) ? "-" : "01";
    }
    
    function get_currency($doc)
    {

        $tags = [':32A:', ':32B:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return substr($result, 6, 3);
              
            }

        }
        return "";
    }
    function get_beneficiary_account($doc)
    {

        $tags = [
            '1' => ':59:',
            '2' => ':59A:',
            '3' => ':59F:',
        ];
        foreach ($tags as $key => $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return $result;
            }
        }
        return "";
    }
    function get_datetime($doc)
    {

        $tags = [
            '}' => '{177:',
            PHP_EOL => ':32A:'];
        foreach ($tags as $key => $tag) {
            $result = $this->string_between($doc, $tag, $key);
            if ($result) {
                return substr($result, 0, 6) . '0000';
            }
        }
        return "";
    }
    function get_beneficiary($doc)
    {

        $tags = [':59:', '59A:', ':59F:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, ":");
            if ($result) {
                return $result;
            }
        }
        return "";
    }
    function get_remittance_info($doc)
    {

        $tags = [':70:', '7:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return $result;
            }
        }
        return "";
    }

    function get_account_institution($doc)
    {

        $tags = [':57D:', ':57A:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return $result;
            }
        }
        return "";
    }

    function get_transaction_amount($doc)
    {

        $tags = [':32B:', ':32A:'];
        foreach ($tags as $tag) {
            $currency = $this->get_currency($doc);
            $result = $this->string_between($doc, $currency, PHP_EOL);
            if ($result) {
                    return ((int) preg_replace("/[^0-9]/", "", $result))/100;
            }

        }
        return "";
    }

    function get_customer($doc)
    {

        $tags = [':50A:', ':50H:', ':50K:', ':50L:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, ":");
            if ($result) {
                return $result;
            }

        }
        return "";
    }

    function get_customer_account($doc)
    {

        $tags = [':50A:', ':50H:', ':50K:', ':50L:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return $result;
            }

        }
        return "";
    }
    function get_io_mode($doc)
    {
        //
        $tags = ['{2:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, '}');
            if ($result) {
                return substr($result, 0, 1);
            }
        }
        return "";
    }

    function get_message_type($doc)
    {
        // tag 32A :32A:200603NGN20000000,00  sometimes has date, but we need to add HHMI
        $tags = ['{2:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, '}');
            if ($result) {
                return substr($result, 1, 3);
            }
        }
        return "";
    }

    function get_reference($doc)
    {
        // get text bewteen 20 and 23 but sometimes it doesnt work, let use : instead of :23B
        $tags = [':20:', ':21:', ':23:'];
        foreach ($tags as $tag) {
            $result = $this->string_between($doc, $tag, PHP_EOL);
            if ($result) {
                return $result;
            }
        }
        return "";
    }

    function get_tag_value($string, $tag, $end = "}")
    {
        $end_tag = isset($end) ? $end : PHP_EOL;
        return trim($this->string_between($string, $tag, $end_tag));
    }

    function string_between($str, $from, $to)
    {
        if (str_contains($str, $from)) {
            $string = substr($str, strpos($str, $from) + strlen($from));
            if (strstr($string, $to, true) != false) {
                $string = strstr($string, $to, true);
            }
            return trim($this->cleanup($string));
        }
        return "";

    }

    function cleanup($str)
    {
        $in = ["/", "{", "}", "\n", "\r"];
        $out = ["", "", "", " ", ""];
        return str_replace($in, $out, $str);
    }

    function contains($string, $sub)
    {
        if (strpos($string, $sub) !== false) {
            return true;
        }
        return false;
    }
}
