#!/usr/bin/perl -w
# its a perl module for creating or deleteing home directories through
# calling it as a cronjob
#
use Data::Dumper::Simple ;
use myThreadCmds;

#no strict 'refs';

if (( defined($ARGV[0])) && ($ARGV[0] ne '')) {
  my $mod=$ARGV[1] ;      
  unless (defined($mod)) {
    print "Call this script like this: $0 <(Arg-1:)/path/to/user-template (Arg-2:)create|change-p|isync> \n";
    exit;
    }
  ## debug ## print "\nmod:/".$mod."/\n" ;
  my $modArg=$ARGV[2] ;      
  if ( defined($ARGV[0])) {
    open (IN, "<$ARGV[0]");
    my $allCmds = '' ;
    while (<IN>) {
      my $line = $_ ;
      chomp($line) ;
      next if ($line eq '') ;
      my ($email, $pass) = $line =~ /^(\S+)\/(\S+)$/ ;
      my $cmd = "";
      SWITCH: {
        $mod =~ /create/ && do { 
      	    $cmd = "dbmail-users -a ".$email."  -p md5sum -w ".$pass." -g 0 -m 3000M -s ".$email."\n";
            last SWITCH; 
            };
        $mod =~ /change-p/ && do { 
      	    $cmd = "dbmail-users -c ".$email."  -p $modArg -w ".$pass."\n" ;
            last SWITCH; 
            }; 
        $mod =~ /isync/ && do { 
            my $outFolder = "/tmp/mail-sync";
            `mkdir -p $outFolder` ;
            `chmod 700 $outFolder` ;
            my($ename, $edomain ) = $email =~ /^(\S+)\@(\S+)$/; 
            my $passFile = $outFolder."/".$ename;
            open (OUT, ">".$passFile);
            print OUT $pass."\n";
	    close (OUT);
            `chmod 600 $passFile` ;
	    #sleep 1 ;
            $cmd  = " imapsync --host1 imap.$YOUR_FQDN --prefix1 '' --sep1 '/' --port1 143 --user1 $email --passfile1";
            $cmd .= " $passFile imapsync --host2 127.0.0.1 --prefix2 '' --sep2 '.' --port2 143 --user2 $email";
            $cmd .= " --passfile2 $passFile --subscribe \n";
            #$cmd .= " --passfile2 $passFile --authmech2 LOGIN \n";
            last SWITCH; 
            }; 
	}
      $allCmds .= $cmd ;
      }
      close(IN) ;
      #print "\n/". ref ($cmd)."/\n";
      my $nn = new myThreadCmds ( \$allCmds ) ;
      #`$cmd`;
      }
    }
else {
 print ("\nplease call me like this: ".$0."</path/to/usertemplate.txt>") ;
  }
