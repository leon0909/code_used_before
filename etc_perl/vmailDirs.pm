# its a perl module for creating or deleteing home directories through
# calling it as a cronjob
#
use Data::Dumper::Simple ;
use DBI;
use strict;

package vmailDirs  ;

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
    my ( $this ) = @_;
    my %properties =() ;
    # .............................................
    $properties{'vmailHome' } = '/home/vmail' ;
    my %homes = ();
    open(F, "/usr/bin/find $properties{'vmailHome'} -maxdepth 2 -type d | grep $YOUR_FQDN\/ |");
    while (defined(my $line = <F>)) {
       chomp($line) ; 
       # our directory names may have / at the end here we renove it.
       $line =~ s/(.*)\/$/$1/ ;
       # ...removed ;
       $homes{$line}='NOUSER';
       }
    close (F) ;
    # .............................................
    $properties{'existingDirs'} = \%homes; 
    # .............................................
    $properties{'tName' } = 'virtual_users' ;
    $properties{'tombDir'} = '/var/vmail/archives';
    $properties{'vmailDir'} = '/home/vmail';
    $properties{'dbName'} = 'mailserver'    ;
    $properties{'host'  } = "127.0.0.1"     ;
    $properties{'port'  } = "3306"     ;
    # .............................................
    $properties{'vdomain'} = { '0' => '$YOUR_FQDN',
 			      '1' => '1-$YOUR_FQDN' } ;
    # .............................................
    $properties{'user'  } = 'ldap'          ;
    $properties{'pass'  } = 'readOnly'      ;
    # .............................................
    my $dsn  = "DBI:mysql:database=$properties{'dbName'};";
    $dsn .= "host=$properties{'host'};";
    $dsn .= "port=$properties{'port'}";
    # .............................................
    $properties{'dsn'} = $dsn;
    # .........................
    %{$this} = %properties ;
    # .........................
    my $query = "SELECT user,domain_id,homeDir FROM $this->{'tName' } WHERE 1";
    $this->getDbData($query);
    $this->checkDirs();
    }
# ......................  
sub debug {
    my ($this,$what) = @_ ;
    unless ($what) { 
      print Dumper($this) ; 
      } else { print Dumper($what) }
    }
# ......................  
sub getDbData {
    my ($this,$queryStr) = @_ ; 
    my $dbh = DBI->connect  (
	$this->{'dsn'},
	$this->{'user'},
	$this->{'pass'},
	{'RaiseError' => 1} );
    # .........................
    my $drh = DBI->install_driver("mysql");    
    # .........................
    $this->{'lastSqlQuery'} = $queryStr;
    # .........................
    my $sth = $dbh->prepare($this->{'lastSqlQuery'});
    $sth->execute or die $sth->errstr;
    $this->{'key_field'} = 'user' ;
    $this->{'virtual_users'} = $sth->fetchall_hashref( $this->{'key_field'} ); 
    $this->{'numRows'} = $sth->rows; 
    }
# ......................  
sub updateData {
    my ($this,$queryStr) = @_ ; 
    my $dbh = DBI->connect  (
	$this->{'dsn'},
	'vmService',
	'onlyVmdirs',
	{'RaiseError' => 1} );
    # .........................
    my $drh = DBI->install_driver("mysql");    
    # .........................
    $this->{'lastSqlQuery'} = $queryStr;
    # .........................
    my $sth = $dbh->prepare($this->{'lastSqlQuery'});
    $sth->execute or die $sth->errstr;
    }
# ..............................
sub rmDirs {
    my ($this) = @_ ; 
    unless ($this->{'nextUser'} ne '') {
       my %uHsh=%{$this->{'virtual_users'}};
       foreach my $key ( keys(%uHsh) ) {
          $this->getVUser($key,\%uHsh);
          }
       }  
    # ..............................
    my %existingDirs = %{ $this->{'existingDirs'} };
    foreach my $key ( keys(%existingDirs) ) {
      # moove vmail directory to archive if a user is not in the virtual_users db.table any more:
      # and put the message in the syslog that it will be deleted through the cronjob in 7 days 
      # 
      if ($existingDirs{$key} eq 'NOUSER') {
         # /home/vmail/1-$YOUR_FQDN/mgibson
         my($tombstone,$vdomain,$userName) = $key =~ /^\/home\/vmail\/((\S+\.org)(.*))$/ ;
         $this->{'tombstoned'} .= " ".$tombstone."," ;
         `mkdir -p $this->{'tombDir'}/$vdomain && mv $key $this->{'tombDir'}/$vdomain/ `;      
         # -> ...
         }
      }
    chop($this->{'tombstoned'});
    $this->{'tombMessage'}  = " the following users were deleted ".$this->{'tombstoned'};
    $this->{'tombMessage'} .= " their mails are tombstoned inside".$this->{'tombDir'};
    $this->{'tombMessage'} .= " and will be automatically deleted in 7 days" ;
    `$this->{'tomMessage'} | /usr/bin/logger ` if ($this->{'tombstoned'} ne '');
    print "\ntombstoned::/$this->{'tombstoned'}/\n" if ($this->{'tombstoned'} ne '');
    }

# ......................  
sub getVUser {
       my ($this, $id ) = @_ ; 
       $this->{'nextVHome'} = $this->{'virtual_users'}{$id}{'homeDir'} ;
       # print "\nHERE::nextVHome::/$this->{'nextVHome'}/\n";
       $this->{'nextUser'} = $this->{'virtual_users'}->{$id}->{'user'} ; 
       if ( $this->{'nextVHome'} ne ''
            && (-e $this->{'nextVHome'})
            ) {
          # our directory names may have / at the end here we renove it.
          $this->{'nextVHome'} =~ s/(.*)\/$/$1/ ;
          # ..removed / ;
          $this->{'allUsers'}{ $this->{'nextUser'} } = $this->{'nextVHome'} ;
	        }
       else {
	        $this->{'allUsers'}{ $this->{'nextUser'} } = 'CREATE';
	        }
       $this->{'existingDirs'}{ $this->{'nextVHome'} } = $this->{'nextUser'}; 
       }
# ......................  
sub makeDirs {
    my ($this) = @_ ; 
    my %uHsh=%{$this->{'virtual_users'}};
   
    foreach my $key ( keys( %{$this->{'virtual_users'}}) ) {
      $this->getVUser($key);
      }
    my %allUser = %{$this->{'allUsers'}} ;
    foreach my $key ( keys( %allUser) ) {
      if ( $allUser{$key} eq 'CREATE' ) {
        # make vmail directory:
        $this->{'allUsers'}{$key} = 
		"$this->{'vmailDir'}/$this->{'vdomain'}{ $this->{'virtual_users'}->{$key}{'domain_id'} }/".$key ;
        $this->createDirs($key) ;
	}
      else {
        ` echo "NO NEW VMAIL USERS FOUND" | /usr/bin/logger ` ;
        }
      }  
    }
# ..............................
sub createDirs {
    my ($this,$user) = @_ ; 
    # at the shell execution: return value if a success is 1 and if not 0 thats why useing: 
    # -> && for the die() function.
    # ..............................
    my $query = "update $this->{'tName' } set homeDir='".$this->{'allUsers'}{$user}."' WHERE user='".$user."'";
    $this->updateData($query);
    # ....lets chek if parent dir exists ........
    my @parts=split("/","/home/vmail/$YOUR_FQDN/sample.user"); 
    pop(@parts) ; 
    my $parentDir = join("/",@parts); 
    my $maildirs=$parentDir.'/'.$user.'/mails/';
    my $sievedir=$parentDir.'/'.$user.'/sieve';
    unless ( -d $parentDir.'/mail' ) {
      my @mda = ('cur','new','tmp');
      foreach my $mdir ( @mda ) {
        $mdir = $maildirs.'/'.$mdir;
        print "\ncreating this directory ::/$mdir/\n" ;
        `mkdir -p $mdir`;
        }
      `mkdir -p $sievedir`;
      `chown -R vmail:vmail $parentDir`;
      }
    # ........................................... 
    my $cmd = "/usr/sbin/useradd -d $this->{'allUsers'}{$user} -s /dev/fals -m ".$user ;
    ` $cmd `  ;
    # && die ("can't create directory:-".$this->{'allUsers'}{$user}."- for new virtual e-mail-user.!".$0." ".$!);
    # ..............................
    # We need to delete the user now to be sure we created only a virtual user and not
    # the system user which is a securety risk, so the following cmd removes it from
    # passwd file but leaves the needed directory structure which
    # remains usable for email-service.
    $cmd = "/usr/sbin/userdel ".$user ;
    ` $cmd ` && die ("can't delete a real user -/".$user."/- to make it a virtual vmail user".$0." ".$!);
    # ..............................
    # and give postfix and dovecot the access rights to it:
    # -> ...
    $cmd = "chown -R vmail:vmail ".$this->{'allUsers'}{$user} ;
    ` $cmd ` ;
    }
# ..............................
sub checkDirs {
      my ($this) = @_ ; 
      $this->makeDirs();
      # $this->rmDirs();
      }  
1;
