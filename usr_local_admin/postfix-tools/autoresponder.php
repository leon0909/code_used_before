#!/usr/bin/php -q
<?
    /*
    goldfish - the PHP auto responder for postfix
    Copyright (C) 2007-2008 by Remo Fritzsche

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    (c) 2007-2009 Remo Fritzsche	(Main application programmer)
    (c)      2009 Karl Herrick		(Bugfix)
    (c) 2007-2008 Manuel Aller		(Additional programming)

    Version 1.0-STABLE
    */

    ini_set('display_errors', true);
    error_reporting( -1 );

    ######################################
    # Check PHP version                  #
    ######################################

    if ( version_compare( PHP_VERSION, "5.0.0" ) == - 1 )
    {
    echo "Error, you are currently not running PHP 5 or later. Exiting.\n";
    exit;
    }

    # Custom functions :: Leon
    # ........................................................
    $patterns =array(
      '#^\s*From:\s*\"*\S*\s*\S*\"*\s*\<\s*(\w+\W*\w+\@\S+\.\D{2,3})\s*\>#i',
      '#^\s*From:\s*\"*.*[^\"*]\s*<\s*(\S+@\S+)\s*\>#i',
      '#^\s*\"*.*[^\"*]\s*<\s*(\S+@\S+)\s*\>#i',
      '#^\s*From: (\w+\W*\w+\@\S+\.\D{2,3})#i',
      '#^\s*(\w+\W*\w+\@\S+\.\D{2,3})#i'
      );
    # ........................................................
    function get_address ($in,$patterns) {
      # echo "\nIN::/".$in."/\n";
      $matches =array();
      foreach ($patterns as $ptrn) {
        preg_match_all (
        $ptrn,
        $in,
        $matches,
        PREG_PATTERN_ORDER
        );
      # print_r($matches);  
      if (isset ($matches[1][0]) ) {
        $result = $matches[1][0] ;
        if (strpos ($result,'@') !== FALSE ) return $result;
        }
      }
    } // end function;
    # ........................................................
    ######################################
    # Configuration                      #
    ######################################
    /* General */
    $conf['cycle'] = 5 * 60;

    /* Logging */
    $conf['log_file_path'] = "/var/log/goldfish/autoresponder.log";
    $conf['write_log'] = true;
    $conf['my_return_path'] = 'vmail@$YOUR_FQDN';

    /* Database information */
    $conf['mysql_host'] = "127.0.0.1";
    $conf['mysql_user'] = "vmService";
    $conf['mysql_password'] = "onlyVmdirs";
    $conf['mysql_database'] = "mailserver";

    /* Database Queries */

    # This query has to return the path (`path`) of the corresponding
    # maildir-Mailbox with email-address %m
    # $conf['q_mailbox_path'] = "SELECT CONCAT('/home/vmail/', SUBSTRING_INDEX(email,'@',-1), '/', SUBSTRING_INDEX(email,'@',1), '/') as `path` FROM users WHERE `email` = '%m'";
    $conf['q_mailbox_path'] = "SELECT CONCAT('/home/vmail/', SUBSTRING_INDEX(email,'@',-1), '/', SUBSTRING_INDEX(email,'@',1), '/mails/') as `path` FROM view_users WHERE `email` = '%m'";    

    # This query has to return the following fields from the autoresponder table: `from`, `to`, `email`, `message` where `enabled` = 2
    $conf['q_forwardings'] = "SELECT * FROM `autoresponder` WHERE `enabled` = 1 AND `force_enabled` = 1"; // MODIFIED!

    # This query has to disable every autoresponder entry which ended in the past
    $conf['q_disable_forwarding'] = "UPDATE `autoresponder` SET `enabled` = 0 WHERE `to` < CURDATE();";

    # This query has to activate every autoresponder entry which starts today
    $conf['q_enable_forwarding'] = "UPDATE `autoresponder` SET `enabled` = 1 WHERE `from` >= CURDATE();";

    # This query has to return the message of an autoresponder entry identified by email %m
    $conf['q_messages'] = "SELECT `message` FROM `autoresponder` WHERE `email` = '%m'";

    # This query has to return the subject of the autoresponder entry identified by email %m
    $conf['q_subject'] = "SELECT `subject` FROM `autoresponder` WHERE `email` = '%m'";

    ######################################
    # Logger class                       #
    ######################################

  class Logger {
      var $logfile;
      var $str;

    function addLine($str) {
      $str = date("Y-m-d h:i:s")." ".$str;
      $this->str .= "\n$str";
      echo $str."\n";
      }

    function writeLog(&$conf) {
      if (! $conf['write_log'] ) return;

      if (is_writable($conf['log_file_path'])) {
        $this->addLine("--------- End execution ------------");
        if (!$handle = fopen($conf['log_file_path'], 'a')) {
          echo "Cannot open file ({$conf['log_file_path']})";
          exit;
          }

        if (fwrite($handle, $this->str) === FALSE) {
          echo "Cannot write to file)";
          exit;
          }
        else {
          echo "Wrote log successfully.";
          }
        fclose($handle);
        }
      else {
        echo "Error: The log file is not writeable.\n";
        echo "The log has not been written.\n";
        }
      }
    } // end class ;

    ######################################
    # Create log object                  #
    ######################################
    $log = new Logger();

    ######################################
    # function endup()                   #
    ######################################
    function endup(&$log, &$conf)
    {
    $log->writeLog($conf);
    exit;
    }

    ######################################
    # Database connection                #
    ######################################
    $link = @mysql_connect($conf['mysql_host'], $conf['mysql_user'], $conf['mysql_password']);
    if (!$link) {
      $log->addLine("Could not connect to database. Abborting.");
      endup($log, $conf);
      }
    else {
      $log->addLine("Connection to database established successfully");

      if (!mysql_select_db($conf['mysql_database'])) {
        $log->addLine("Could not select database ".$conf['mysql_database']);
        endup($log, $conf);
        }
      else {
        $log->addLine("Database selected successfully");
        }
      }

    ######################################
    # Update database entries            #
    ######################################
    $result = mysql_query($conf['q_disable_forwarding']);

    if (!$result)  {
      $log->addLine("Error in query ".$conf['q_disable_forwarding']."\n".mysql_error());
      }
    else {
      $log->addLine("Successfully updated database (disabled entries)");
      }

    mysql_query($conf['q_enable_forwarding']);

    if (!$result) {
      $log->addLine("Error in query ".$conf['q_enable_forwarding']."\n".mysql_error());
      }
    else {
      $log->addLine("Successfully updated database (enabled entries)");
      }

    ######################################
    # Catching dirs of autoresponders mailboxes #
    ######################################

    // Corresponding email addresses
    $result = mysql_query($conf['q_forwardings']);

    if (!$result) {
      $log->addLine("Error in query ".$conf['q_forwardings']."\n".mysql_error());
      exit;
      }

    # echo $conf['q_forwardings'] ;
    $num = mysql_num_rows($result);

    for ($i = 0; $i < $num; $i++) {
      $emails[] = mysql_result($result, $i, "email");
      $name[] = mysql_result($result, $i, "descname");
      }

    # print_r($emails);

    // Fetching directories
    for ($i = 0; $i < $num; $i++) {
      $lastQuery = str_replace("%m", $emails[$i], $conf['q_mailbox_path']);
    # echo "\nI-COUNT:/$i/\n" ;
    # echo "\nlastQuery:/$lastQuery/\n" ;
      $result = mysql_query($lastQuery);
      if (!$result)	{
        $log->addLine("Error in query ".$conf['q_mailbox_path']."\n".mysql_error()); 
        exit; 
        }
      else {
        $log->addLine("Successfully fetched maildir directories for ".$emails[$i]); 
        }
      // Mine had to be modified to cur/ since my server was moving files from new/ to cur/ right away.
      $paths[] = mysql_result($result, 0, 'path') . 'new/'; 
      # .............................................................
      # I do this mapping here : because the count of the passes equails the count of the emails that are 
      # acted on by this autoresponder ; --
      $user_paths[$emails[$i]] = mysql_result($result, 0, 'path') . 'new/'; 
      $name2emails[$emails[$i]] = $name[$i];
      # .............................................................
      }
    ######################################
    # Reading new mails                  #
    ######################################
    if ($num > 0) {
      # looks like this : 1332861402.M446258P7273.smtp,S=805,W=824 
      foreach ($user_paths as $email => $path) {
        $i = 0;
        foreach(scandir($path) as $entry) {
          if ($entry != '.' && $entry != '..') {
            $abs_path=$path . $entry;
            $fletime = filemtime($abs_path) ;
            $difftime = ( time() - $fletime - $conf['cycle'] ) ;
            # $difftime = ( time() - $fletime ) ;
            $debug = "abs_path:/".$abs_path."/\n";
            $debug .= "fletime:/".$fletime."/\n";
            $debug .= "cycle-time:/".$conf['cycle']."/\n";
            $debug .= "difftime:/".$difftime."/\n";
            # echo $debug ; 
            if ($difftime >= 0) {
              $mails[ $path . $entry ] = $email;
              }
            } 
          } // end foreach-2 ;
        $i ++;  
        } // end foreach-1; 
      } // end if ;  
    # print_r($user_paths) ;
    # print_r($name2emails) ;
    # print_r($mails) ;
    # ..............................................
          ###################################
          # Send response                   #
          ###################################
    # ..............................................
    foreach ( $mails as $abs_path => $email ) {
      // Reading mail address
      if ( file_exists( $abs_path ) ) {
        $mail = file($abs_path);
        }
      else {
        continue ;
        }
      # .............................
      foreach ($mail as $line) {
        # ........................................
        $line = trim($line); 
        if (substr($line, 0, 12) == 'Return-Path:') { 
          # ........................................
          $returnpath = substr($line, strpos($line, '<') + 1, strpos($line, '>') - strpos($line,'<')-1)."\n"; 
          $returnpath = rtrim($returnpath);
          # echo "\nreturnpath: ".$returnpath."\n";
          } 
        # ........................................
        if (!( $address = get_address($line,$patterns) )) { 
          # ........................................
          if ( isset ($returnpath) ) $address = $returnpath; 
          } 
        if (isset ($address) && isset($returnpath) ) {
          # echo "\naddress: ".$address."\n";
          break;
          }
        } 
        // Check: Is this mail allready answered
      if (empty($address)) {
        $log->addLine("Error, could not parse mail $abs_path of $email from $user_paths[$email] ");
        continue ;
        }
      else {
        # ........................................
        // Get data of current mail
        // Get subject that was preset in the database as an  autoresponce Subj. 
        $result = mysql_query(str_replace("%m", $email, $conf['q_subject']));       
        if (!$result) {
          # ........................................
          $log->addLine("Error in query ".$conf['q_subject']."\n".mysql_error()); 
          exit;
          }
        else {
          # ........................................
          $log->addLine("Successfully fetched subject of {$email}");
          }
        $subject = mysql_result($result, 0, 'subject');
        // Get Message
        $lastQuery = str_replace("%m", $email, $conf['q_messages']);
        #echo "\nQ_Messages:".$lastQuery."\n";
        $result = mysql_query($lastQuery);          
        if (!$result) {
          # ........................................
          $log->addLine("Error in query ".$conf['q_messages']."\n".mysql_error()); 
          exit;
          }
        else {
          # ........................................
          $log->addLine("Successfully fetched message of {$email}");
          }
        # ........................................
        $message = mysql_result($result, 0, 'message');
        $headers = "From: ".$name2emails[$email]." <".$email.">\n" ;
        # echo "\nheaders:/".$headers."/\n";
        # ........................................
        $defi=strlen('/new');
        $cur_path = substr($user_paths[$email],0,-$defi)."cur/";
        // Check if mail is allready an answer:
        if ( substr($address,0,strlen($address)-1) == $email 
          || $address == $conf['my_return_path'] ) {
          # ..............................................
          $out  = "Email address:/".$address."/ from autoresponder table is the same";
          $out .= " as the intended recipient! Not sending the mail! Setting status of ";
          $out .= "this mail to sent without sending further responds.\n" ;
          # ..............................................
          $log->addLine($out);
          system ( 'mv '.$abs_path.' '.$cur_path ) ;
          # ..............................................
          echo $out."and loop break;\n";
          break;
          }
        
          /* echo " mail(address, subject, message, $headers)\n";
          echo " mail($address, $subject, message, $headers)\n";
          echo " i:/$i/::mail_i:/$abs_path/::cur_path:/$cur_path/::\n";
          exit; */
          $out = mail($address, $subject, $message, $headers) ;
          sleep (3) ;
          if ($out)  system ( 'mv '.$abs_path.' '.$cur_path ) ;
          }
        } // end foreach send mail ;  
    # ..............................................
    endup ($log, $conf);
    echo "End execution.";
?>
