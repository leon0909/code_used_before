# its a perl module for creating or deleteing home directories through
# calling it as a cronjob
#
use Data::Dumper::Simple ;
use DBI;
use strict;
#no strict 'refs';


package rejectedOff ;

sub new {
    # ......................................................
    my $selfName = shift;
    my $this     =    {};
    # .. Referenz auf anonymen hash ;
    bless($this, $selfName);
    $this->_init(@_);
    return $this;
    } # end sub ;
# ...................
sub _init {
# .............................
    my ( $this, $dbPort, $maillog ) = @_;
    die ("you need to provide the ssh tunel connection portNr to be created \n
          for ssh-mysql tunnel connection as a first argument of the object \n
          initiation" ) if ($dbPort eq '') ;
    die ("you need to provide the /path/to/mail.log|mail-log.0|mail.log.1  \n
          as a second argument of the object initiation" ) if ($dbPort eq '') ;
    # ...HERE WE SET Rejected Email address - structure object variables ...
    # ...and sort them accordingly to their rejection cause ................
    # ...
    my %properties =() ;
    $properties{'maillog'} = $maillog ;
    $properties{'mailSender'} = 'office';
    $properties{'reject-variants' } = {
      '454 4.7.1' =>'Rejection Nr 454 and dsn=4.7.1_Recipient address rejected. User is at or over their disk quota, try again later',
      # ...........................................
      '450 4.1.1' =>'Rejection Nr. 450 and dsn=4.1.1_Recipient address rejected. User unknown in local recipient table',
      '450 4.1.8' =>'Rejection Nr. 450 and dsn=4.1.8_Sender address rejected. Domain not found',
      '450 4.0.0' =>'Rejection Nr. 450 and dsn=4.0.0_Recipient address rejected. undeliverable address',
      '450 4.2.2' =>'Rejection Nr. 450 and dsn=4.2.2_This mailbox is overfilled, new e-mails are not being accepted for delivery anymore.',
      '421 4.4.0' =>'Rejection Nr. 421 and dsn=4.4.0 no MXs for this domain could be reached at this time, -the dommain has no any own email servers anymore?',
      # ...........................................
      '513 5.1.3' =>'Rejection Nr. 513 and dsn=5.1.3_Recipient unknown on this server',
      '550 5.1.1' =>'Rejection Nr. 550 and dsn=5.1.1_Recipient address rejected',
      '550 5.0.0' =>'Rejection Nr. 550 and dsn=5.0.0_mailbox unavailable',
      '550 4.0.0' =>'Rejection Nr. 550 and dsn=4.0.0_We dont accept mail from spamers',
      '550 5.1.6' =>'Rejection Nr. 550 and dsn=5.1.6_Recipient address rejected. User has moved',
      '550 5.2.1' =>'Rejection Nr. 550 and dsn=5.2.1_Unknown user or mailbox deactivated',
      '550 5.2.2' =>'Rejection Nr. 550 and dsn=5.2.2_mailbox is full over quota, - no mail is accepted anymore',
      '550 5.7.1' =>'Rejection Nr. 550 and dsn=5.7.1_RESOLVER.RST.NotAuthorized, the recepient is not an email server user anymore.',
      '550 Mailbox' =>'Rejection Nr. 550 and no dsn_Just Mailbox unavailable',
      '550 Unrouteable address' =>'Rejection Nr. 550 and no dsn_Just Unrouteable address( Mailbox unavailable )',
      'Unrouteable address' =>'Rejection Nr. 550 and no dsn_Just Unrouteable address( Mailbox unavailable )',
      # ...........................................
      '553 5.1.1' =>'Rejection Nr. 553 and dsn=5.1.1_Either the eandamil address was falsely typed or the person has moved',
      'no mailbox' =>'Rejection Nr. 553 and dsn=5.1.1_Either the eandamil address was falsely typed or the person has moved',
      # ...........................................
      '554 5.0.0' =>'Rejection Nr. 554 and dsn=5.0.0_Recepients mail server permanently rejects this message',
      '554 5.2.2' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'over quota' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'Over quota' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'quota exceeded' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'Quota exceeded' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'mailbox exceeds' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'mailfolder is full' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'mailbox is full' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'automatically rejected:' =>'Rejection Nr. 554 and dsn=5.2.2_Delivery failed: Delivery Mailbox is over the quota. -Long time no more used?',
      'mail disabled' =>'Rejection Nr. 554,The recepients email server tels: Recepient has disabled his mailbox',
      'No such user' =>'Rejection Nr. 550, Unrouteable address or unknown mailbox',
      'no such user' =>'Rejection Nr. 550, Unrouteable address or unknown mailbox',
      'invalid mailbox' =>'Rejection Nr. 550, Unrouteable address or invalid mailbox',
      'no such local user' =>'Rejection Nr. 550, Unrouteable address or unknown mailbox',
      'possible mail loop' =>'554 5.4.6 possible mail loop, all redirec addresses are no more active?',
      'Unrouteable address' =>'Rejection Nr. 550, Unrouteable address or unknown mailbox'
      };
    # .............................................
    $properties{'getRjaAddsBashLog' } = '/usr/local/admin/postfix-tools/getRejeMailAds-from-log.sh';
    $properties{'getRjaAddsBashBounces' } = '/usr/local/admin/postfix-tools/getRejeMailAds-fromMails.sh';
    # .............................................
    $properties{'tName' } = 'Member'    ;
    $properties{'dbName'} = '$someName_md'    ;
    $properties{'host'  } = '127.0.0.1' ;
    $properties{'dbPort'  } = $dbPort   ;
    $properties{'user'  } = '$someName_md'    ;
    $properties{'tmpSQLfile'} = "/tmp/rejOFFs.sql";
    # .............................................
    $properties{'sshTunnel2MySql'} = 'ssh -f w-data@62.241.61.17 -L '.$dbPort.':127.0.0.1:23306 -N ' ;
    $properties{'getSSHTunnelPID'} = "ps ax|  grep ".$dbPort." | grep -v grep | awk '{print $1}' " ;
    # .............................................
    $properties{'tempSQL2MySql'}   = "mysql -u".$properties{'user'}." -h".$properties{'host'} ;
    $properties{'tempSQL2MySql'}  .= " -P".$properties{'dbPort'}." ".$properties{'dbName'}    ;
    $properties{'tempSQL2MySql'}  .= " < ".$properties{'tmpSQLfile'};
    # .............................................
    %{$this} = %properties ;
    $this->getRejections();
    $this->createSwitchOffQueries();
    $this->switchOffInDB();

    #$this->sendNotifications();
    # .............................................
    } # init end;
# ...................
sub createSwitchOffQueries {
    # .............................................
    my ($this) = @_ ;
    my @parts=();
    my %rejects=();
    $this->{'query'} = '' ;
    foreach my $rejVnt (keys(%{$this->{'reject-variants' } } ) ) {
      @parts = (split ' ', $rejVnt)   ;
      foreach my $rejEmail (keys %{$this->{'rejectedMails'}->{$parts[0]}->{$parts[1]} } ) {
        my $whyDisabled = $this->{'rejectedMails'}->{$parts[0]}->{$parts[1]}{$rejEmail};
        $this->{'queries'}{$rejEmail} = ' UPDATE '.$this->{'tName' }.' set `Newsletter`="no", `LetterDisabled`="'.$whyDisabled.'" WHERE `Email`="'.$rejEmail.'" and `Status`="valid" ';
        $this->{'query'} .= ' UPDATE '.$this->{'tName' }.' set `Newsletter`="no", `LetterDisabled`="'.$whyDisabled.'" WHERE `Email`="'.$rejEmail.'" ;'."\n";
        }
      }
    open SQLOUT, ">".$this->{'tmpSQLfile'} or die $! ;
    print SQLOUT $this->{'query'} ;
    close SQLOUT;
    my @rejCount = keys(%{$this->{'queries' } } ) ;
    $this->{'queries'}{'count'} = $#rejCount +1;
    }  
# ...................
sub getSQLError {
    # .............................................
    my ($this,$errstr,$errquery,$qCount) = @_ ;
    print "\n".$errstr;
    print "QueryCount:".$qCount;
    print "\n".$errquery;

    }  
# ...................
sub switchOffInDB {
    # .............................................
    my ($this) = @_ ;
    # first of all create ssh tunnel to the www.$YOUR_FQDN's MySql
    # on 127.0.0.1:$this->{'dbPort'} ;
    $this->createSSHtunnel2Mysql ;
    sleep 2;
    # ...................................
    my $dsn  = "DBI:mysql:database=".$this->{'dbName'}.";";
    $dsn .= "host=".$this->{'host'}.";" ;
    $dsn .= "port=".$this->{'dbPort'} ;
    $dsn .= "password=''" ;
    #printf ("dsn:%s\n", $dsn);
    #printf ("user:%s\n", $this->{'user'});
    #exit;
    # ...................................
    $this->{'lastBashCmd'} = $this->{'tempSQL2MySql'} ;
    open(
         F, $this->{'lastBashCmd'}." |"
         );
    # ...................
    while (defined(my $line = <F>)) {
       print "\n".$line."\n" ;
       }
    close (F) ;   

    # .........................
    my $dbh = DBI->connect  ( $dsn, $this->{'user'}, '', {'RaiseError' => 1} );
    my $drh = DBI->install_driver("mysql");
    # ........................................
    $this->{'lastQuery'} = "SELECT count(*) FROM `Member` WHERE `Newsletter`='yes' and `Status`='valid'" ;
    my $sth = $dbh->prepare($this->{'lastQuery'});
    $sth->execute or $this->getSQLError(
                 $sth->errstr,
                 $this->{'lastQuery'},
                 '1') ;
    $this->{'key_field'} = 'count(*)' ;
    $this->{'Newsletter_yes'} = $sth->fetchall_hashref( $this->{'key_field'} );
    my @out = keys (%{ $this->{'Newsletter_yes'} }) ;
    $this->{'Newsletter_yes'} = $out[0] ;
    # ........................................
    $this->{'lastQuery'} = "SELECT count(*) FROM `Member` WHERE `Newsletter`='no' and `Status`='valid'" ;
    my $sth = $dbh->prepare($this->{'lastQuery'});
    $sth->execute or $this->getSQLError(
                 $sth->errstr,
                 $this->{'lastQuery'},
                 '1') ;
    $this->{'key_field'} = 'count(*)' ;
    $this->{'Newsletter_no'} = $sth->fetchall_hashref( $this->{'key_field'} );
    my @out = keys (%{ $this->{'Newsletter_no'} }) ;
    $this->{'Newsletter_no'} = $out[0] ;
    # ........................................
    $sth->finish();
    $dbh->disconnect();

    print "\nSwitched off  ".$this->{'queries'}{'count'}." E-mail Entries this time\n";
    print "\nAll the disabled Newsletter E-mail Entries amount to : $this->{'Newsletter_no'} \n";
    print "\nActive Newsletter E-mail Entries left: $this->{'Newsletter_yes'} \n";
    # print Dumper($this->{'Newsletter_yes'}) ;
    $this->killSSHtunnel2Mysql ;
    }
# ...................
sub killSSHtunnel2Mysql {
    # .............................................
    my ($this) = @_ ;
    $this->{'lastBashCmd'} = $this->{'getSSHTunnelPID'} ; 
    open(
         F, $this->{'lastBashCmd'}." |"
        );
    # ...................
    while (defined(my $line = <F>)) {
      chomp($line) ;
      $this->{'sshPID'} = $line;
      }
    close (F) ;

    system('kill -9 '.$this->{'sshPID'}.' > /dev/null 2>&1') ;
    }
# ...................
sub createSSHtunnel2Mysql {
    # .............................................
    my ($this) = @_ ;
    system ($this->{'sshTunnel2MySql'}.' &') ;
    }
# ...................
sub sendNotifications {
    # .............................................
    my ($this) = @_ ;
    foreach my $blhost (keys(%{$this->{'entSpamm' } } ) ) {
      # .............................................
      $this->{'entSpamm'}{$blhost}{'message'} =<<EOT
Dear postmaster,

this message is sent to you bacause, the Mail Log sentry - script of the smtp.$YOUR_FQDN  has noted, 
judging on the status messages in the mail-log file, that you has set smtp.$YOUR_FQDN in your local blacklist, and you are
blocking our messages to a person with this $this->{'entSpamm'}{$blhost}{'count'} e-mail address.

Please note that our e-mail server, doesn't send neither commercial advertisments nor an internet spam, 
being a server of a seriouse scientific organisation that unites the medicine scientists of Europe centering 
their researches on neurology.  

Please understand that the person using this e-mail address: $this->{'entSpamm'}{$blhost}{'count'}, 
has freely set oneself into th news distribution system of our orgaisation, or a Scientific Society 
Administrator did this by through the Society Member status update procedure.

These persons can easily put themselfs from our distribution list by accessing our webpage and setting the
Newsletter selction box to No, using his/her memberships personal information edition form. 
hier is the link to this form: http://www.$YOUR_FQDN/md/member/

It would be surelly a more democratical ( and only slitely more complicated ) way to solve the same problem.

  Best regards,

  Mail Log Sentry(PERL) i.o.  postmaster\@$YOUR_FQDN
EOT
    # .............................................
      }
    } # sendNotifications end;
# ...................
sub parse4rejections {
    # .............................................
    my ($this,$rejVnt) = @_ ;
    my @parts = split(' ',$rejVnt) ;     
    # ...getting rejects that come up in the mail.log file here: ........................
    $this->{'lastBashCmd'} = $this->{'getRjaAddsBashLog' }." ".$parts[0]." ".$parts[1]." ".$this->{'maillog'};
    # debug: print "\n".$this->{'lastBashCmd'}."\n";
    open(
      F, $this->{'lastBashCmd' }." |"
      );
    # ...................
    while (defined(my $line = <F>)) {
      chomp($line) ; 
      next if ($line eq '') ;
      #$line =~ s/(.*)\/$/$1/ ;
      $this->{'rejectedMails'}{$parts[0]}{$parts[1]}{$line} = $this->{'reject-variants' }{$rejVnt};
      }
    close (F) ;
    # ...getting rejects that come up in the Bounce Mails to the office@$YOUR_FQDN ...
    # ...as the bulk mail sender :................
    $this->{'lastBashCmd'} = $this->{'getRjaAddsBashBounces' }." ".$this->{'mailSender'}." ".$parts[0]." ".$parts[1];
    # debug:   print "\n".$this->{'lastBashCmd'}."\n";
    
    open(
      F, $this->{'lastBashCmd' }." |"
      );
    # ...................
    while (defined(my $line = <F>)) {
      chomp($line) ; 
      next if ($line eq '') ;
      #$line =~ s/(.*)\/$/$1/ ;
      $this->{'rejectedMails'}{$parts[0]}{$parts[1]}{$line} = $this->{'reject-variants' }{$rejVnt};
      }
    close (F) ;
    # ...................
    if ($rejVnt eq '550 4.0.0') {
      $this->{'entSpamm'}{'subject'} = "Unjustly set RejectionCode=550 dsn=4.0.0 : We dont accept mail from spamers" ;
      # ...................
      my %blListed = ();   
      if (defined $this->{'rejectedMails'}{$parts[0]}{$parts[1]} ) {
        %blListed = %{ $this->{'rejectedMails'}{$parts[0]}{$parts[1]} } ;
        }
      my %blLhosts = () ;
      # ...................
      undef(%{$this->{'rejectedMails' }{$parts[0] }{$parts[1] } });  
      # ...................
      foreach my $blMailAdr ( keys (%blListed) ) {
        my @parts = split ('@',$blMailAdr) ;
        $blLhosts{$parts[1]}{$blMailAdr} = $this->{'entSpamm'}{'subject'};
        my @count = keys(%{$blLhosts{$parts[1] } } ) ;
        $blLhosts{"count@".$parts[1]} = $#count +1 ;
        }
      # ...................
      $this->{'entSpamm'}{'blServers'}=\%blLhosts;
      # ...................
      }
    # ...................
    } # end function; ..................
# ...................
sub getRejections {
    # .............................................
    my ($this) = @_ ;
    # .............................................
    foreach my $rejVnt (keys(%{$this->{'reject-variants' }} ) ) {
      # .........................
      $this->parse4rejections($rejVnt) ;
      # .........................
      } 
    # .............................................
    } # getRejections end;
# ...................
sub debug {
    my ($this,$what) = @_ ;
    unless ($what) {
      print Dumper($this) ;
      } 
    else { 
      print Dumper($what) 
      }
    } # debug end;
# ...................
                        
1;
