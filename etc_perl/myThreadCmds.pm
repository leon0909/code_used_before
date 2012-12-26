use strict;
use warnings;
use Parallel::ForkManager;
use Data::Dumper::Simple ;

package myThreadCmds  ;

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
    my ( $this, $cmd_list  ) = @_;
    my %properties = ();
    $properties{'Arg1_type'} = ref($cmd_list) if defined($cmd_list);
    # .............................
    my $out = "\nYou need to provide a list of comands as an array reference \n
commands to be exacuted as threads, -as your module initiation parameter. \n
it is either empty or not a refernce to an ARRAY or SCALAR -this time.\n";
    unless ( $properties{'Arg1_type'} ) {
      # .............................
      die ($out);
      } 
    else {
      unless (($properties{'Arg1_type'} eq "SCALAR") or ($properties{'Arg1_type'} eq "ARRAY")) {
        $out .= 'Actually what you provided as the argument was a :/'.$properties{'Arg1_type'}."/\n";
        die ($out);
        }
      # .............................................
      %{$this} = %properties ; 
      $this -> doThreads($cmd_list);
      }
  } # End of _init ;
# ...................
sub doThreads {
    # .............................
    my ( $this, $cmd_list  ) = @_;
    SWITCH: {
      ($this->{'Arg1_type'} eq "SCALAR") && do {
          my @commands = split ("\n", ${$cmd_list});
          chomp(@commands);
          $this->{'commands'} = \@commands;
          $this->checkAndThread();
          last SWITCH;
          };
      ($this ->{'Arg1_type'} eq "ARRAY") && do {
          $this->{'commands'} =  $cmd_list;
          $this->checkAndThread();
          last SWITCH;
          };
      return $this->{'Arg1_type'};
      } 
  } # End sub ;
# ...................
sub checkAndThread {
  # .............................
  my ( $this ) = @_;
  my $pm = new Parallel::ForkManager(3);  
  my $count=0 ;
  foreach my $cmd (@{$this->{'commands'}}) {
    if ($cmd =~ /^\s+rm\s.\-f\s+/) {         
      print "\ndangerouse command: $cmd -will not perform. \n";
      next;
      }
    $pm->start and next;
    my ($cmdId) = $cmd =~ /^.*\s\S+\/(\S+)\s\S+\s\S+\s*$/ ;
    #print "\n/".$cmd."/\n";
    if (!$cmdId) {
      warn "cannot create Process Identifire useing the counter instead";
      $cmdId = "$count";
      }
    else {  
      $cmdId = $cmdId."\@your-real-domain-name-here.org";
      }
    $0 .= " ".$cmdId;
    print "Forked $cmdId\n" ;
    my $rc = system ("$cmd") ;
    print "Synced $cmdId\n" ;
    $pm->finish;
    $count++ ;
    }
  }
# ...................
1;
