<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;


class MailController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    public function password_reset(Request $request)
    {

        $request_content = $request->getContent();
        $recipient = json_decode($request_content);
        
        //return $request_content;
       //return 'Password reset';
        $mail = new PHPMailer(true);

        try {
            //Server settings
            //$mail->SMTPDebug = SMTP::DEBUG_SERVER; //Enable verbose debug output
            $mail->isSMTP(); //Send using SMTP
            $mail->Host = env('MAIL_HOST'); //Set the SMTP server to send through
            $mail->SMTPAuth = true; //Enable SMTP authentication
            $mail->Username = env('MAIL_USERNAME'); //SMTP username
            $mail->Password = env('MAIL_PASSWORD'); //SMTP password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; //Enable implicit TLS encryption
            $mail->Port = env('MAIL_PORT'); //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

            //Recipients
            $mail->setFrom(env('MAIL_FROM_ADDRESS'), env('MAIL_FROM_NAME'));
            $mail->addAddress($recipient->email); //Add a recipient
            //$mail->addAddress('ellen@example.com'); //Name is optional
            //$mail->addReplyTo('tech-support@novajii.com.com', 'Technical Support');
            //$mail->addCC('cc@example.com');
            //$mail->addBCC('bcc@example.com');

            //Attachments
            //$mail->addAttachment('/var/tmp/file.tar.gz'); //Add attachments
            //$mail->addAttachment('/tmp/image.jpg', 'new.jpg'); //Optional name

            //Content
            $mail->isHTML(true); //Set email format to HTML
            $mail->Subject = env('PASSWORD_RESET_SUBJECT');
            $mail->Body = "<p style=\"font-size: 11px\">Use this token to reset your password:<br/><br/><strong>Token: <string>&nbsp; "
            .$recipient->key."<br/><br><a href=".$recipient->url.">Click Here To Reset Password</a></p>";
            //$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

            $mail->send();
            $request_content = $request->getContent();
            return response()->json([
                'status'=>'success',
                'message'=>'Sent'
            ]);
        } catch (Exception $e) {
            //return "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
            return response()->json([
                'status'=>'error',
                'message'=>$mail->ErrorInfo
            ]);
        }
        
    }

    //
}
