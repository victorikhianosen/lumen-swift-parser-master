<?php

function contains($string, $sub)
{
    if (strpos($string, $sub) !== false) {
        return true;
    }
    return false;
}

function string_between($string, $start, $end)
{
    $string = ' ' . $string;
    $ini = strpos($string, $start);
    if ($ini == 0) return '';
    $ini += strlen($start);
    $len = strpos($string, $end, $ini) - $ini;
    return substr($string, $ini, $len);
}

function tag_value($str, $tag, $end = "}")
{
    return string_between($str, $tag, $end);
}

function parse($tokens)
{
    $result = [];
    foreach ($tokens as $message1) {

        if (strpos($message1, "{1:F21") == FALSE) {

            $header = tag_value($message1, "1:F01");
            $text = tag_value($message1, "{4:", "-}");
            $text = str_replace(array("\n","\r"), '', $text);
            $text = trim(preg_replace('/\s\s+/', ' ', str_replace("\n", " ", $text)));
            $stamp = '32A';
            $block4 = get_block4_tester($text);
            $time = substr(get_block4_tester($text)[$stamp],0,6);
            $data["ServiceId"] = contains($message1, "F01") ? "01" : "-";
            $data["Acknowledgment"] = tag_value($message1, "1:F01");
            $data["ApplicationId"] = substr($header, 0, 1);
            $data["TerminalAddress"] = substr(tag_value($message1, "1:F01"), 0, 12);
            $data["SessionNumber"] = substr(tag_value($message1, "1:F01"), -10, 4);
            $data["SequenceNumber"] = substr(tag_value($message1, "1:F01"), -6);
            $app = tag_value($message1, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = $time;
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $user = tag_value($message1, "3:");
            $data["BankPriorityCode"] = tag_value($message1, "113:");
            $data["MessageUserReference"] = tag_value($message1, "108:");
            $data["AOK"] = tag_value($message1, "433:");
            $data['Text'] = $text;
            var_dump($text);
            $result[] = $data;
            
        }else{
            $header = tag_value($message1, "1:F01");
            $data["ServiceId"] = contains($message1, "F01") ? "01" : "-";
            $data["Acknowledgment"] = tag_value($message1, "1:F21");
            $data["ApplicationId"] = substr($header, 0, 1);
            $data["TerminalAddress"] = substr(tag_value($message1, "1:F21"), 0, 12);
            $data["SessionNumber"] = substr(tag_value($message1, "1:F21"), -10, 4);
            $data["SequenceNumber"] = substr(tag_value($message1, "1:F21"), -6);
            $app = tag_value($message1, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = substr($app, 4, 10);
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $user = tag_value($message1, "3:");
            $data["BankPriorityCode"] = tag_value($message1, "113:");
            $data["MessageUserReference"] = tag_value($message1, "108:");
            $data["AOK"] = tag_value($message1, "433:");
            $text = tag_value($message1, "4:\r\n", "-}");

            $data['Text'] = $text;
            $result[] = $data;
            
        }
    }
    return $result; 
}

function parse_tester($tokens)
{
$result = [];
    foreach ($tokens as $message1) {

        if (strpos($message1, "{1:F21") == FALSE) {

            $header = tag_value($message1, "1:F01");
            $text = tag_value($message1, "{4:", "-}");
            $text = str_replace(array("\n","\r"), '', $text);
            $text = trim(preg_replace('/\s\s+/', ' ', str_replace("\n", " ", $text)));
            $stamp = '32A';
            $block4 = get_block4_tester($text);
            $time = substr(get_block4_tester($text)[$stamp],0,6);
            $data["ServiceId"] = contains($message1, "F01") ? "01" : "-";
            $data["Acknowledgment"] = tag_value($message1, "1:F01");
            $data["ApplicationId"] = substr($header, 0, 1);
            $data["TerminalAddress"] = substr(tag_value($message1, "1:F01"), 0, 12);
            $data["SessionNumber"] = substr(tag_value($message1, "1:F01"), -10, 4);
            $data["SequenceNumber"] = substr(tag_value($message1, "1:F01"), -6);
            $app = tag_value($message1, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = $time;
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $user = tag_value($message1, "3:");
            $data["BankPriorityCode"] = tag_value($message1, "113:");
            $data["MessageUserReference"] = tag_value($message1, "108:");
            $data["AOK"] = tag_value($message1, "433:");
            $data['Text'] = $text;
            var_dump($text);
            $result[] = $data;
            
        }else{
            $header = tag_value($message1, "1:F01");
            $data["ServiceId"] = contains($message1, "F01") ? "01" : "-";
            $data["Acknowledgment"] = tag_value($message1, "1:F21");
            $data["ApplicationId"] = substr($header, 0, 1);
            $data["TerminalAddress"] = substr(tag_value($message1, "1:F21"), 0, 12);
            $data["SessionNumber"] = substr(tag_value($message1, "1:F21"), -10, 4);
            $data["SequenceNumber"] = substr(tag_value($message1, "1:F21"), -6);
            $app = tag_value($message1, "2:");
            $data["Mode"] = substr($app, 0, 1);
            $data["MessageType"] = substr($app, 1, 3);
            $data["Timestamp"] = substr($app, 4, 10);
            $data["RecipientBIC"] = substr($app, 14, 12);
            $data["MessagePriority"] = substr($app, -1);
            $user = tag_value($message1, "3:");
            $data["BankPriorityCode"] = tag_value($message1, "113:");
            $data["MessageUserReference"] = tag_value($message1, "108:");
            $data["AOK"] = tag_value($message1, "433:");
            $text = tag_value($message1, "4:\r\n", "-}");

            $data['Text'] = $text;
            $result[] = $data;
            
        }
    }
    return $result; 
}

function get_block4($msg)
{
    $re = '/((\\\\r\\\\n)+)/';
    $str = $msg;

    $stripped = preg_replace($re, '', $str);
    $clean = '/([\d,A-Z,a-z]+)(:)([\d,a-z,A-Z,\\\\\/,\s,-]+)/';
    $matches = [];
    preg_match_all($clean, $msg, $matches, PREG_PATTERN_ORDER, 0);

    $index = 0;
    $arr = [];

    foreach ($matches[1] as $field) {
        $value = $matches[3][$index];
        $arr[$field] = $value;
        $index++;
    }
    return($arr);
}

function get_block4_tester($msg)
{
            $re = '/((\\\\r\\\\n)+)/';
            $str = $msg;

            $stripped = preg_replace($re, '', $str);
            $clean = '/([\d,A-Z,a-z]+)(:)([\d,a-z,A-Z,\\\\\/,\s,-]+)/';
            $matches = [];
            preg_match_all($clean, $msg, $matches, PREG_PATTERN_ORDER, 0);

            $index = 0;
            $arr = [];

            foreach ($matches[1] as $field) {
                $value = $matches[3][$index];
                $arr[$field] = $value;
                $index++;
            }
            return($arr);
}


function run($msg)
{   
    $str = $msg;
    $tokens = explode('}${', $str);
    $cnt = count($tokens);
    $result = parse($tokens);
    return json_encode(["Items" => $result, "Count" => $cnt]);

}

function tester($msg)
{   
    $str = $msg;
    $tokens = explode('}${', $str);
    $cnt = count($tokens);
    $result = parse_tester($tokens);
    echo(json_encode(["Items" => $result, "Count" => $cnt]));
}

tester('{1:F21FIDTNGLAAXXX4373561068}{4:{177:2106211535}{451:0}}{1:F01FIDTNGLAAXXX4373561068}{2:O2021535210621CBNINGLBAXXX08852757332106211535N}{3:{113:0003}{108:000150000}{121:1e854bff-017b-4954-ab5a-48dc603e7057}}{4:
    :20:P54014420/8
    :21:NONREF
    :32A:210621NGN3488205669,71
    :53A:/D/3000024646
    FIDTNGLA
    :58A:/C/81000098099CL
    CBNINGLA
    :72:/CODTYPTR/012
    /CLEARING/0003
    /SGI/FIDTNGLA
    -}{5:{MAC:00000000}{CHK:4851254A1532}}{S:{SAC:}{COP:S}}${1:F21FIDTNGLAAXXX4373561069}{4:{177:2106211535}{451:0}}{1:F01FIDTNGLAAXXX4373561069}{2:O9001535210621CBNINGLBAXXX08852757452106211535N}{3:{113:0003}{108:000150000}}{4:
    :20:954015039/900
    :21:P54014420/8
    :25:3000024646
    :32A:210621NGN3488205669,71
    :52D:CBNINGLAACH
    :72:/CLEARING/0003
    /SGI/FIDTNGLA
    /ESETDATE/2106211528+0000
    /OID/210621CBNINGLAAACH0002049095
    -}{5:{CHK:1C7256D74639}}{S:{COP:S}}');