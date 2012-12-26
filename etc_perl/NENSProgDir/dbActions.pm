use Data::Dumper::Simple ;
use DBI;
use lib qw(/etc/perl/NENSProgDir);
use strict;
no strict 'refs';


package dbActions ;
sub new {
  # .............................................
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
  my ( $this, $WhatToDo,$sqlQuery,$DBTable ) = @_;
  my %properties =() ;
  ($DBTable) ?  my ($db,$table) = $DBTable =~ /^(.*?)\.(.*)$/
    : die ("\nNo dbname.table data was given at module initialisation!\n") ;
  $properties{'toDo'} = $WhatToDo       ;
  $properties{'dbTable'} = $table       ;
  $properties{'dbName'}  = $db          ;
  $properties{'dbPort'} = '3306'        ;
  $properties{'host'  } = '127.0.0.1'   ;
  $properties{'dbUser'  } = $db         ;
  $properties{'sqlQuery'  } = $sqlQuery ;
  # .............................................
  %{$this} = %properties ;
  $this->doWhatsToBeDone();
  } # end sub ;
# ...................
sub doWhatsToBeDone {
  my ($this) = @_ ;
  WHATTODO: {
   ($this->{'toDo'} eq 'check') 
    && do {
      $this->{lastQuery} = $this->{'sqlQuery'} ;
      $this->{'key_field'} = 'ID';
      $this-> checkIfEntryExists() ;
      last WHATTODO;
      };
   ($this->{'toDo'} eq 'IsttnRows') 
    && do {
      $this->{lastQuery} = $this->{'sqlQuery'} ;
      $this->{'key_field'} = 'InstitutionID';
      $this-> checkIfEntryExists() ;
      last WHATTODO;
      };
   ($this->{'toDo'} eq 'multiRows') 
    && do {
      $this->{lastQuery} = $this->{'sqlQuery'} ;
      $this->{'key_field'} = 'CourseID';
      $this->dbQueryExec();
      last WHATTODO;
      };
   ($this->{'toDo'} ne 'check') 
    && do {
      $this->{'key_field'}='';
      $this->{lastQuery} = $this->{'sqlQuery'} ;
      $this->dbQueryExec();
      last WHATTODO;
      };
    }
  } # end sub ;

# ...................
sub checkIfEntryExists {
  # returns true if entry already exists
  # ...................
  my ($this) = @_ ;
  $this->dbQueryExec();

  printf("query:/%s/\nCCCCresultSet:/%s/\n",
    $this->{'lastQuery'}, 
    $this->{'resultSet'}
    );
  $this->{'emptySet'} = 'yes' unless ($this->{'resultSet'});
  $this->{'emptySet'} = 'no'  if ($this->{'resultSet'});
  } #  end sub;

# ...................
sub dbQueryExec {
    # .............................................
    # needs to have $this->{'lastQuery'} be preset to a SQL Query
    # exmpl.: "SELECT count(*) FROM `Member` WHERE `Newsletter`='yes' and `Status`='valid'" ;
    #
    # set $output to "yes" if something is awaited as such

    my ($this, $output) = @_ ;
    # ...................................
    my $dsn  = "DBI:mysql:database=".$this->{'dbName'}.";";
    $dsn .= "host=".$this->{'dbHost'}.";" ;
    $dsn .= "port=".$this->{'dbPort'}.";" ;
    #$dsn .= "user=".$this->{'dbUser'}.";" ;
    # $dsn .= "password=".$this->{'dbPass'} ;
    # printf ("dsn:%s\n", $dsn);
    # printf ("user:%s\n", $this->{'user'});
    # exit;
    # .........................
    my ($dbh,$drh) =('',''); 
    $dbh->{mysql_enable_utf8} = 1; 
    $dbh= DBI->connect  ( $dsn, $this->{'dbUser'}, '', {'RaiseError' => 1} ) or die($!);
    $drh = DBI->install_driver("mysql");
    $dbh->do('SET NAMES \'utf8\';') || die();
    # ........................................
    # if ( $this->{'lastQuery'} =~ /view/) {
    #  printf("%s",Dumper($this->{'lastQuery'}));
    #  }

    printf("%s",Dumper($this->{'lastQuery'}));
    my $sth = $dbh->prepare($this->{'lastQuery'});
    $sth->execute or die ( 
        "Cannot execute this query:".$this->{'lastQuery'}."\n"
        .$this->getSQLError( $sth->errstr, $this->{'lastQuery'}, '1' )
      );
    SQLQUERIES: {             
      # .........................
        ($output ne 'insert')
        and ($output ne 'update')
        and $this->{'key_field'} ne '' 
        and $this->{'toDo'} eq 'check' 
        and do { # THIS IS 4-SELECT QUERIES ONLY ..!...
          # ...........................
          $this->{'lastDBOutput'} = $sth->fetchall_hashref( $this->{'key_field'} ) ;
          my $key ='';
          my %rss=%{ $this->{'lastDBOutput'} } ;
          foreach $key (keys %rss ) {
            if ($key ne '') {
              $this->{'resultSet'} = $key if ($key ne '');
              last;
              }
            }
  print "\ndbA_ result set:$this->{'resultSet'}\n";
          last SQLQUERIES ;
          };
      # .........................
        ($output ne 'insert')
        and ($output ne 'update')
        and $this->{'key_field'} ne '' 
        and $this->{'toDo'} eq 'IsttnRows' 
        and do { # THIS IS 4-SELECT QUERIES ONLY ..!...
          # ...........................
          $this->{'lastDBOutput'} = $sth->fetchall_hashref( $this->{'key_field'} ) ;
          my $key ='';
          my %rss=%{ $this->{'lastDBOutput'} } ;
          foreach $key (keys %rss ) {
            if ($key ne '') {
              $this->{'resultSet'} = $key if ($key ne '');
              last;
              }
            }
  print "\ndbA_ result set:$this->{'resultSet'}\n";
          last SQLQUERIES ;
          };
        # .........................
        ($output ne 'insert')
        and ($output ne 'update')
        and $this->{'key_field'} ne '' 
        and $this->{'toDo'} eq 'multiRows' 
        and do { # and THIS IS 4-SELECT QUERIES ONLY with multiple result ..!...
          undef($this->{'resultSet'}) ;
          my $ref;
          my $count=0;
          while ( $ref = $sth->fetchrow_hashref( ) 
            ) {
            $this->{'lastDBOutput'}->{$count} = $ref ;
            push ( @{$this->{'resultSet'}},  $count ); 
            $count ++ ;
            }
  print "\nWWA_ result set:$this->{'resultSet'}";
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
1;
__END__
