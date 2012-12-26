# its a perl module for creating or deleteing home directories through
# calling it as a cronjob
#

use Data::Dumper::Simple ;
use MIME::Base64::Perl ;
use DBI ;
use vmailDirs ;
use strict;
no strict 'refs';


package emailActions;
$emailActions::call = 'my $nn = new emailActions';

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
    my ( $this, $toDo, $paramsRef ) = @_;
    my %properties =() ;
    # .............................
    %{$properties{'params'}} =(
      'action'=>$toDo,
      'ref:actionParams'=>$paramsRef
      ) ;
    # .............................
    # ...HERE WE SET Rejected Email address - structure object variables ...
    # ...and sort them accordingly to their rejection cause ................
    # ...
    # .............................................
    %{$properties{'dbTablesTypes' }} = (
      'data_list'       => 'rw',
      #.........................
      'view_users'      => 'ro',
      'view_aliases'    => 'ro',
      #.........................
      'virtual_users'   => 'rw',
      'virtual_aliases' => 'rw',
      'virtual_domains' => 'rw'
      );
    # .............................................
    my %vaccounts_fields = (
      'id'=>'NULL',
      'user_id'=>'',
      'account'=>''
      );
    # .............................................
    my %valiases_fields = (
      'id'=>'NULL',
      'domain_id'=>'',
      'source'=>'',
      'destination'=>''
      );
    # .............................................
    my %vusers_fields = (
      'id'=>'NULL',
      'domain_id'=>'',
      'user'=>'',
      'password'=>'',
      'pw_hashed'=>'', 
      'homeDir'=>'', 
      'master_user'=>'false',
      'proxy_host'=>'127.0.0.1', 
      'proxy_imap_port'=>'10143',
      'proxy_pop3_port'=>'10110'
      );
    $properties{'virtual_users_fields'} = \%vusers_fields;
    $properties{'virtual_aliases_fields'} = \%valiases_fields;
    $properties{'virtual_accounts_fields'} = \%vaccounts_fields;
    # .............................................
    $properties{'dbName'}   = 'mailserver'   ;
    $properties{'dbHost'  } = 'localhost'    ;
    $properties{'dbPort'  } = '3306'         ;
    $properties{'dbUser'  } = 'emailActions' ;
    $properties{'dbPass'  } = 'Isa74Wuff'    ;
    # .............................................
    %{$this} = %properties ;
    $this->allChecks();
    # .............................................
    $this->parseParams();
    $this->performActions();
    } # end init sub;
# ...................
sub in_array {
  my ($this, $arr, $search_for) = @_;
  #printf("\narr_nodel:%s\nsearch_fore:%s\n",Dumper($arr),$search_for);
  return grep {$search_for eq $_} @$arr;
  }
# ...................
sub mkHshdPass {    
    my ($this) = @_ ;
    $this->{'txt2md5'}  = 'doveadm pw -p' ;
    $this->{'txt2md5'} .= $this->{'params'}->{'ref:actionParams'}->{'passwd'} ;
    $this->{'txt2md5'} .= ' -s CRAM-MD5' ;
    open(
         F, $this->{'txt2md5'}." |"
         );
    # ...................
    while (defined(my $line = <F>)) {
       next if ($line eq '');
       chomp($line);
       $this->{'md5pass'}=$line;
       # print "\nline:/".$line."/\n" ;
       }
    close (F) ;   
    } # end init sub;
# ...................
sub parseParams {    
    my ($this) = @_ ;
    $this->{'domain'} = $this->{'params'}->{'ref:actionParams'}->{'domain'} if (
      defined ( $this->{'params'}->{'ref:actionParams'}->{'domain'} )
      );
    if ($this->{'params'}->{'ref:actionParams'}->{'email' } ne '') {
      ($this->{'uname'},$this->{'domain'}) = $this->{'params'}->{'ref:actionParams'}->{'email'} =~ /^(.*)\@(.*)$/; 
      }
    $this->{'lastQuery'}  = "SELECT id from virtual_domains WHERE name=\"".$this->{'domain'}."\";";
    $this->{'key_field'} = 'id' ;
    $this->dbQueryExec();
    $this->{'virtual_users_fields'}->{'domain_id'} = 
        $this->{'lastDBOutput'}->{$this->{'resultSet'}}->{$this->{'key_field'}};
    # ...................................................................
    die (
         " the e-mail domain of your e-mail address: ".$this->{'domain'}
        ." - isn't hosted on this e-mail server.\n Have"
        ." you misspelled the e-mail address?\n "
        ." The skript execution is aborted for now.\n"
        ) unless ( 
          defined( $this->{'virtual_users_fields'}->{'domain_id'})
          and $this->{'virtual_users_fields'}->{'domain_id'} ne ''
          );  
    # ...................................................................
    # ...................................................................
    PARAMS: {
      ( $this->{'params'}->{'ref:actionParams'}->{'passwd'} ne '' 
        ) and do {
        # ...................................................................
        foreach my $key (keys %{$this->{'lastDBOutput'}}) {
          next unless (defined $this->{'lastDBOutput'}->{$key});
          # ...................................................................
          $this->{'virtual_users_fields'}->{'user'} = $this->{'uname'} ;
          $this->{'virtual_users_fields'}->{'password'} = $this->{'params'}->{'ref:actionParams'}->{'passwd'};
          $this->mkHshdPass();
          $this->{'virtual_users_fields'}->{'pw_hashed'} = $this->{'md5pass'};
          # ...................................................................
          $this->{'virtual_aliases_fields'}->{'domain_id'} = $this->{'lastDBOutput'}->{$key}->{$this->{'key_field'}};
          $this->{'virtual_aliases_fields'}->{'destination'} = $this->{'params'}->{'ref:actionParams'}->{'email'} ;
          $this->{'virtual_aliases_fields'}->{'source'} = $this->{'uname'} ;
          # ...................................................................
          $this->{'virtual_accounts_fields'}->{'account'} = MIME::Base64::Perl::encode_base64 (
             # ...................................................
             $this->{'params'}->{'ref:actionParams'}->{'email'}
             ."/"
             .$this->{'params'}->{'ref:actionParams'}->{'passwd'}
             # ...................................................
             );
          }
        # ...................................................................
        last PARAMS;
        };
      # ...................................................................
      ( $this->{'params'}->{'action'} eq 'list' ) 
        and do {
        # ...................................................................
        $this->{'lastQuery'}  = "select u.id, u.user, a.account from virtual_users u ";
        $this->{'lastQuery'} .= "inner join virtual_accounts a on u.id=a.user_id ;";
        if ($this->{'uname'} ne '') {
          chop($this->{'lastQuery'});
          $this->{'lastQuery'} .= "where u.user='".$this->{'uname'}."'; ";
          }
        # ...................
        #$this->listEmails();
        # ...................................................................
        last PARAMS;
        };
      # ...................................................................
      ( $this->{'params'}->{'ref:actionParams'}->{'email' } ne ''
        and $this->{'params'}->{'ref:actionParams'}->{'target'} ne '' 
        ) and do {
        # ...................................................................
        foreach my $key (keys %{$this->{'lastDBOutput'}}) {
          # ...................................................................
          next unless (defined $this->{'lastDBOutput'}->{$key});
          # ...................................................................
          $this->{'virtual_aliases_fields'}->{'domain_id'} = $this->{'lastDBOutput'}->{$key}->{$this->{'key_field'}};
          $this->{'virtual_aliases_fields'}->{'destination'} = $this->{'params'}->{'ref:actionParams'}->{'target'} ;
          $this->{'virtual_aliases_fields'}->{'source'} = $this->{'uname'} ;
          }
        last PARAMS;
        };
      }  
    } # end sub;
# ...................
sub mkInsertQry {    
    my ($this, $tableName) = @_ ;
    my (@fields, @values) = ((),());
    my ($md5k, $md5v, $acc5k, $acc5v, $IDk, $IDv) = ('','','','','','') ;
    foreach my $key ( keys %{$this->{$tableName."_fields"}} ) {
      PARSE: {
        ($key ne 'password'
         and $key ne 'id') 
         and do {
          push (@fields, $key) ;
          push (@values, $this->{$tableName."_fields"}->{$key}) ;
          last PARSE;
          };
        ($key eq 'id') 
         and do {
          $IDk = $key ;
          last PARSE;
          };
        ($key eq 'password') 
         and do {
          $md5k = $key ;
          $md5v = $this->{$tableName."_fields"}->{$key};
          last PARSE;
          };
        }
      }  
    my $out  = 'insert into '.$tableName.' ( `' ;
    if ($tableName =~ /users/ ) {
      $out .= join('`,`', @fields).'`,`'.$md5k.'`,`'.$IDk.'`' ;
      $out .= ') values ( "' ;
      $out .= join('","', @values).'", MD5("'.$md5v.'"), NULL ' ;
      $out .= ');' ; # end insert query pts.
      }
    else {
      $out .= join('`,`', @fields).'`,`'.$IDk.'`' ;
      $out .= ') values ( "' ;
      $out .= join('","', @values).'",  NULL ' ;
      $out .= ');' ; # end insert query pts.
      }
    $out ;
    } # end init sub;
# ...................
sub performActions {    
    my ($this) = @_ ;
    ACTIONS: {
      $this->{'params'}->{'action'} eq 'add' && do {
        $this->addEmail();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'delEmail' && do {
        $this->deleteEmail();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'newPass' && do {
        $this->changeEmailPass();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'showRedirects' && do {
        $this->listRedirections();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'addRedirect' && do {
        $this->addRedirect();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'delRedirect' && do {
        $this->delRedirect();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'redirect' && do {
        $this->redirectEmailTo();
        last ACTIONS;
        };
      $this->{'params'}->{'action'} eq 'list' && do {
        $this->listEmails();
        last ACTIONS;
        };
      }  
    # .............................................
    } #  end sub;
# ...................
sub checkIfEntryExists {
    # returns true if email already exists
    # ...................
    my ($this) = @_ ;
    $this->dbQueryExec();
    #printf("\n%s\n",Dumper( $this->{'lastDBOutput'} ));
    #exit;
    ($this->{'lastDBOutput'}->{$this->{'resultSet'}}->{$this->{'key_field'}}>0) 
    ? return 1
    : return 0
    } #  end sub;
# ...................
sub addEmail {
    # executes all needed SQL Queries 
    # to create a new email account
    # ...................
    my ($this) = @_ ;    
    $this->{'lastQuery'}  = "SELECT count(*) from view_users WHERE email=\"";
    $this->{'lastQuery'} .= $this->{'params'}->{'ref:actionParams'}->{'email'}."\"; ";
    $this->{'key_field'} = 'count(*)' ;
    unless ( $this->checkIfEntryExists() ) {
      # ...................
      $this->{'lastQuery'}  = $this->mkInsertQry('virtual_users');
      $this->dbQueryExec('insert');
      # ...................
      $this->{'lastQuery'}  = $this->mkInsertQry('virtual_aliases');
      $this->dbQueryExec('insert');
      sleep (1) ;
      # ...................
      $this->{'lastQuery'}  = 'select id, user from virtual_users where user="'.$this->{'uname'}.'";';
      $this->{'key_field'}='id';
      $this->dbQueryExec();
      $this->{'virtual_accounts_fields'}->{'user_id'} = $this->{'lastDBOutput'}->{$this->{'resultSet'}}->{$this->{'key_field'}}; 
      # printf("%s\n",Dumper($this->{'lastDBOutput'}->{$this->{'resultSet'}}));
      # ......................
      $this->{'lastQuery'}  = $this->mkInsertQry('virtual_accounts');
      # printf("%s",Dumper($this->{'lastQuery'}));
      # ......................
      # adds the Email address in the user database
      # ......................
      $this->dbQueryExec('insert');
      # ......................
      # creates needed diretory structure for the new Email Address
      # ......................
      my $nn = new vmailDirs(); 
      }
    else {
      # ...................
      die (
        "\nthere already exists such an email:"
        .$this->{'params'}->{'ref:actionParams'}->{'email'}
        ."\nin the database. You can use the - list - parameter"
        ."\nto show you the information of this existing email");
      }
    } #  end sub;
# ...................
sub deleteEmail {
    my ($this) = @_ ;
    $this->{'key_field'} = 'id';
    $this->{'lastQuery'} = 'select id from virtual_users where user="'.$this->{'uname'}.'";';
    if ($this->checkIfEntryExists()) {
    # we should have aour result set after the execution of checkIfEntryExists ;
    # ...........................
    $this->{'deleteId'} = $this->{'lastDBOutput'}->{$this->{'resultSet'}}->{$this->{'key_field'}};
    # ...........................
    undef($this->{'key_field'});
      $this->{'lastQuery'} = 'delete from virtual_users where user="'.$this->{'uname'}.'";';
      $this->dbQueryExec();
      $this->{'lastQuery'} = 'delete from virtual_accounts where user_id="'.$this->{'deleteId'}.'";';
      $this->dbQueryExec();
    # ...........................
      # ... a no - delete array |
      # ....................... v
      my @nd = (
        'applications',
        'awards',
        'awards2',
        'birgit.jarchow',
        'britta.morich',
        'care',
        'clemens.webert',
        'david.speck',
        'dbmail.dev',
        'dominique.poulain',
        'elections',
        'events.forum',
        'forum2012',
        'forum2014',
        'forum2016',
        'forum2018',
        'grants.forum',
        'helmut.kettenman',
        'history',
        'lars.kristiansen',
        'leonid.heidt',
        'meino.gibson',
        'mihaela.vincze',
        'nens',
        'nensunil.archive',
        'neurotrain',
        'office',
        'olga.zvyagintseva',
        'pc.com',
        'php.www',
        'postmaster',
        'programme.forum',
        'proposals.forum',
        'proxy.pass',
        'schools',
        'stipends',
        'tanja.butzek',
        'webmaster',
        'venus.mail'
        ) ;
    # ... End no - delete array ...;
    # ..............................
      unless ( $this->in_array( \@nd, $this->{'uname'} ) ) {
        printf("\n%s\n","deleteing "
        .$this->{'uname'}.'@'.$this->{'domain'}
        ." together with the emaildirectory " );
        }
      else {
        printf("\n%s\n","removing of the emaildirectory for this account"
        .$this->{'uname'}.'@'.$this->{'domain'}." is not allowed" );
        }
      }
    else {
      printf(
        "\n%s\n",$this->{'uname'}.'@'.$this->{'domain'}
        ." cannot be found in the mailserver database anymore.\n"
        ." Was it even there ?"
        );
      }
    printf("\n%s\n", "The following redirects concerning the deleted eMail still exist");  
    $this->listRedirections();
    printf("\n%s\n", "Please decide for yourself if you wisch to remove them!");  
    } #  end sub;
# ...................
sub changeEmailPass {
    my ($this) = @_ ;
    $this->{'lastQuery'}  = 'select count(*) from virtual_users where user="'.$this->{'uname'}.'"; ';
    $this->{'key_field'} = 'count(*)';
    # ...We check if the e-mail user exists.....
    if ($this->checkIfEntryExists()) {
      # ... So he/she exists ... update her password in the postfix/dovecote table
      $this->{'lastQuery'}  = 'update virtual_users set password=';
      $this->{'lastQuery'} .= 'MD5("'.$this->{'virtual_users_fields'}->{'password'}.'"), ';
      $this->{'lastQuery'} .= 'pw_hashed="'.$this->{'md5pass'}.'" where user="'.$this->{'uname'}.'"; ';
      undef($this->{'key_field'});
      $this->dbQueryExec();
      # ... So he/she exists ...  get the user id for the further actions
      $this->{'lastQuery'}  = "SELECT id from virtual_users WHERE user=\"";
      $this->{'lastQuery'} .= $this->{'uname'}."\"; ";
      $this->{'key_field'} = 'id' ;
      $this->dbQueryExec();
      # ... So he/she exists ... update her password in a password control list
      $this->{'id2beChanged'} = $this->{'lastDBOutput'}->{$this->{'resultSet'}}->{$this->{'key_field'}};
      $this->{'lastQuery'}  = 'update virtual_accounts set account="';
      $this->{'lastQuery'} .= $this->{'virtual_accounts_fields'}->{'account'};
      $this->{'lastQuery'} .= '" where user_id="'.$this->{'id2beChanged'}.'"; ';
      undef($this->{'key_field'});
      $this->dbQueryExec();
      printf("\n%s\n",'the password is now changed.');
      }
    else {
      printf(
        "\n%s\n",$this->{'uname'}.'@'.$this->{'domain'}
        ." cannot be found in the mailserver database anymore.\n"
        ." Was it even there ?"
        );
      }
    } #  end sub;
# ...................
sub delRedirect {    
    my ($this) = @_ ;
    my $token = $this->{'uname'}.'@'.$this->{'domain'}."->";
    $token   .= $this->{'virtual_aliases_fields'}->{'destination'};
    #check if the redirection already exists:
    $this->{'lastQuery'}  = 'select count(*) from virtual_aliases where source="'.$this->{'uname'}.'" ';
    $this->{'lastQuery'} .= 'and destination="'.$this->{'virtual_aliases_fields'}->{'destination'}.'" ; ';
    $this->{'key_field'} = 'count(*)';
    if ($this->checkIfEntryExists()) {
      print "\nremoving this: --- ".$token." ---";
      print " redirection....\n";
      $this->{'lastQuery'}  = 'delete from virtual_aliases where source="'.$this->{'uname'}.'" ';
      $this->{'lastQuery'} .= 'and destination="'.$this->{'virtual_aliases_fields'}->{'destination'}.'" ; ';
      undef ($this->{'key_field'});
      $this->dbQueryExec();
      print " .....Done.\n";
      }
    else {  
      print "\nI cannot delete the redirection: \n";
      print $token;
      print "\ncannot be found in the database. Are you sure that such one Existed? \n";
      }
    } #  end sub;
# ...................
sub addRedirect {    
    my ($this) = @_ ;
    #check if the redirection already exists:
    $this->{'lastQuery'}  = 'select count(*) from virtual_aliases where source="'.$this->{'uname'}.'" ';
    $this->{'lastQuery'} .= 'and destination="'.$this->{'virtual_aliases_fields'}->{'destination'}.'" ; ';
    $this->{'key_field'} = 'count(*)';
    if ($this->checkIfEntryExists()) {
      printf(
        "\n%s\n", 
        "Redirectionf from ".$this->{'uname'}.'@'.$this->{'domain'}." to "
        .$this->{'virtual_aliases_fields'}->{'destination'}
        ."is already exists. Don't have to do anything."
        );
      }
    else {  
      print "\nAdding a new redireciton....\n";
      # ........................................
      $this->{'lastQuery'}  = $this->mkInsertQry('virtual_aliases');
      undef ($this->{'key_field'});
      $this->dbQueryExec('insert');
      # ........................................
      print "\n".$this->{'uname'}.'@'.$this->{'domain'}.' -> '
      .$this->{'virtual_aliases_fields'}->{'destination'}."\n";
      print "\n....everythig is done\n";
      # ........................................
      }
    } #  end sub;
# ...................
sub redirectEmailTo {
    my ($this) = @_ ;
    # printf("%s\n",Dumper());
    $this->{'lastQuery'}  = 'update virtual_aliases set destination="';
    $this->{'lastQuery'} .= $this->{'virtual_aliases_fields'}->{'destination'}.'" where ';
    $this->{'lastQuery'} .= 'source="'.$this->{'uname'}.'";';
    undef($this->{'key_field'});
    $this->dbQueryExec();
    sleep (1);
    $this->listRedirections();
    } #  end sub;
# ...................
sub listRedirections {    
    my ($this) = @_ ;
    $this->{'key_field'}  = 'id';
    $this->{'lastQuery'}  = 'select id, source, destination from virtual_aliases where source="'.$this->{'uname'}.'";';
    $this->dbQueryExec();
    if ($this->{'resultSet'}) {
      foreach my $key (keys %{$this->{'lastDBOutput'}}) {
        printf( 
          "\n %s -> %s \n",
          $this->{'lastDBOutput'}->{$key}->{'source'}.'@'.$this->{'domain'},
          $this->{'lastDBOutput'}->{$key}->{'destination'}
          ) ;
        } # end foreach.2
      }
    else {
      printf( "\n %s  \n","> NONE <");
      }
    } #  end sub;
# ...................
sub listEmails {    
    my ($this) = @_ ;
    foreach my $key1 (keys %{$this->{'lastDBOutput'}}) {
      # ..............................
      next unless (defined $this->{'lastDBOutput'}->{$key1});
      # ..............................
      $this->getB64Accounts();
    # printf("\nQuery: %s\n %s \n",$this->{'lastQuery'},Dumper($this->{'lastDBOutput'}));
    # exit;
      if ( $this->{'params'}->{'ref:actionParams'}->{'email' } ne '' ) {
        $this->printList($this->{'resultSet'});
        }
      else {
        foreach my $key2 (keys %{$this->{'lastDBOutput'}}) {
          $this->printList($key2);
          } # end foreach.2
        } # ends else
      } # end foreach.1
    } # end sub;
# ...................
sub printList {
    my ($this, $key) = @_ ;
    $this->{'virtual_accounts_fields'}->{'account'} = MIME::Base64::Perl::decode_base64(
      $this->{'lastDBOutput'}->{$key}->{'account'}
      );
    printf( 
      "\nUser: %s Password: %s \n",
      $this->{'virtual_accounts_fields'}->{'account'} =~ /(.*)\/(.*)/
      );
    } # end sub;
# ...................
sub getB64Accounts {
    my ($this) = @_ ;
    # ...................
    $this->{'key_field'}='id';  
    $this->dbQueryExec();
    } #  end sub;
# ...................
sub Email {
    my ($this) = @_ ;
    printf("%s\n",'bin in Email which is not yet defined');
    } #  end sub;
# ...................
sub dbQueryExec {
    # .............................................
    # needs to have $this->{'lastQuery'} be preset to a SQL Query
    # expl.: "SELECT count(*) FROM `Member` WHERE `Newsletter`='yes' and `Status`='valid'" ;
    #
    # set $output to "yes" if something is awaited as such

    my ($this, $output) = @_ ;
    # ...................................
    my $dsn  = "DBI:mysql:database=".$this->{'dbName'}.";";
    $dsn .= "host=".$this->{'dbHost'}.";" ;
    $dsn .= "port=".$this->{'dbPort'}.";" ;
    $dsn .= "password=".$this->{'dbPass'} ;
    #printf ("dsn:%s\n", $dsn);
    #printf ("user:%s\n", $this->{'user'});
    #exit;
    # .........................
    my $dbh = DBI->connect  ( $dsn, $this->{'dbUser'}, '', {'RaiseError' => 1} );
    my $drh = DBI->install_driver("mysql");
    # ........................................
    # if ( $this->{'lastQuery'} =~ /view/) {
    #  printf("%s",Dumper($this->{'lastQuery'}));
    #  }
    my $sth = $dbh->prepare($this->{'lastQuery'});
    $sth->execute or die ( 
        "It Seems that this e-mail address is already in use.\n"
        .$this->getSQLError(
        $sth->errstr, $this->{'lastQuery'}, '1'
        )
      );
    SQLQUERIES: {             
      # .........................
        ($output ne 'insert')
        and ($output ne 'update')
        and $this->{'key_field'} ne '' 
        and do { # SO THIS IS 4-SELECT QUERIES ONLY  
          $this->{'lastDBOutput'} = $sth->fetchall_hashref( $this->{'key_field'} ) ;
          my $key ='';
          undef($this->{'resultSet'}) ;
          foreach $key (keys %{ $this->{'lastDBOutput'} } ) {
            $this->{'resultSet'} = $key if ($key ne '');
            }
          last SQLQUERIES ;
          };
      # .........................
      # .........................
      # .........................
      } # end LABEL;

    # ........................................
    $sth->finish();
    $dbh->disconnect();
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
sub debug {
    my ($this,$what) = @_ ;
    unless ($what) {
      print Dumper($this) ;
      } 
    else { 
      print Dumper($what) ;
      }
    } # debug end;
# ...................
sub allChecks {
    my ($this) = @_ ;
    foreach my $par (keys %{ $this->{'params'} }) {
      die ("\n
................................................\n    
Aborted execution! : -No \"$par\" argument has been privided.-
.............\n    
Ausführung abgebrochen! : -Kein \"$par\" Argument ist angegeben worden.-
.............\n    
L'exécution avortée! : -le \"$par\" argument a été fourni.-
.............\n    
\nProvided Args.: ".Dumper($this->{'params'})."
\nThis object should be initialised as follows:
\n\t $emailActions::call (< delEmail | add | redirect | addRedirect | delRedirect | showRedirects | newPass| list > < \\%actionParams > ); \n
................................................\n    
" ) unless (
      defined ($this->{'params'}->{$par}) 
      ) ;
    } # end foreach;
    # .............................
    my $paramType = ref($this->{'params'}->{'ref:actionParams'});
    die ("\n
Your second initialization param needs to be a hash reference.\n"
    ) if ($paramType eq '');
    # .............................
    die ("\n
You need to reach the second param -paramsRef- as a hash reference.\n
It needs to be looking like: \%SomeName \n
What I get is $paramType which is not a HASH.\n
Aborted") if ($paramType ne 'HASH');
    }
                        
1;
