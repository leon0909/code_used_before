#!/usr/bin/perl
# ...................................
use Data::Dumper::Simple ;
use emailActions ;
# ...................................

  my ($mod,$email,$mod2,$pass,$target) = ('','','','','') ;
#....................................
  $mod=$ARGV[0] ;
  $email=$ARGV[1] ;
  if (defined($ARGV[2])) {
    ($mod2,$pass)= $ARGV[2] =~ /^(pw):(.*)$/ ;
    ($mod2,$target)= $ARGV[2] =~ /^(to):(.*)$/ unless ( defined ($mod2) );
    unless ( defined ($mod2) ) {
      #................................
      die ( "The third Arg. needs to be either 'to:some.email@domain.org' or 'pw:SomEpaSsword'");
      }
    }  
#....................................
# printf ("\nmod:%s\nemail:%s", $mod, $email);
#....................................
  unless (defined($ARGV[1])) {
    #................................
    print << "END";
call me like this:
$0 <ARG> <ARG> [<ARG>]

for example:
  
  $0 addEmail test.mail\@$YOUR_FQDN pw:testPass

  $0 deleteEmail test.mail\@$YOUR_FQDN 
   
  $0 showPass test.mail\@$YOUR_FQDN

  $0 changePass test.mail\@$YOUR_FQDN pw:anotherPass
  
  $0 showPass all

  $0 showRedirections test.mail\@$YOUR_FQDN

  $0 addRedirection  from:test.mail\@$YOUR_FQDN to:test1.mail2\@$YOUR_FQDN
  ( lets the -to- email become all the messages that 
    come to -from- email as well as its own mail )
  
  $0 delRedirection  from:test.mail\@$YOUR_FQDN to:test1.mail2\@$YOUR_FQDN
  (removes redirection only for the from-email to the to-email )

  $0 redirect from:test.mail\@$YOUR_FQDN to:test1.mail2\@$YOUR_FQDN 
  (disables the -from- account and makes the -to- account receive its emails)

  or

  $0 redirect from:test.mail\@$YOUR_FQDN to:test.mail\@$YOUR_FQDN 
  (enables email test.mail\@$YOUR_FQDN account again)

END
#....................................
    }
#....................................
my %tt = ();
PARSOPTS:{
 ($email eq 'all' ) && do {
   %tt=(q(domain)=>q($YOUR_FQDN));
   my $nn = new emailActions(q(list),\%tt);
   last PARSOPTS;
   };
 ($email =~ /^(.*)\@(.*)$/ ) && do {
   if ($mod eq 'addEmail') {
     unless (defined($ARGV[2])) {
       die ('You need to specify the "pw:SomePassword" as third argument.')
       }
     else {  
       %tt=(
         q(email)=>qq($email),
         q(passwd)=>qq($pass)
         ); 
       my $nn = new emailActions(q(add),\%tt);
       }
     }
   elsif ($mod eq 'deleteEmail') {
     %tt=(
       q(email)=>qq($email)
       ); 
     my $nn = new emailActions(q(delEmail),\%tt);
     }
   elsif($mod eq 'changePass') {
     %tt=(
       q(email)=>qq($email),
       q(passwd)=>qq($pass)
       ); 
     my $nn = new emailActions(q(newPass),\%tt);
     }
   elsif($mod eq 'showPass') {
     %tt=(q(email)=>qq($email)); 
     my $nn = new emailActions(q(list),\%tt);
     }
   elsif($mod eq 'addRedirection') {
     ($mod2,$email) = $email =~ /^(from):(.*)$/;
     %tt=(q(email)=>qq($email),
          q(target)=>$target
          ); 
     my $nn = new emailActions(q(addRedirect),\%tt);
     }
   elsif($mod eq 'delRedirection') {
     ($mod2,$email) = $email =~ /^(from):(.*)$/;
     %tt=(q(email)=>qq($email),
          q(target)=>$target
          ); 
     my $nn = new emailActions(q(delRedirect),\%tt);
     }
   elsif($mod eq 'showRedirections') {
     %tt=(q(email)=>qq($email)); 
     my $nn = new emailActions(q(showRedirects),\%tt);
     }
   elsif($mod eq 'redirect') {
     %tt=(
       q(email)=>qq($email),
       q(target)=>$target
       ); 
     my $nn = new emailActions(q(redirect),\%tt);
     }
   last PARSOPTS;
   };
  }
