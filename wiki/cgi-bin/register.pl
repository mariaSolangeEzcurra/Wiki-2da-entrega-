#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
my $userName=$q->param('userName');
my $password=$q->param('password');
my $firstName=$q->param('firstName');
my $lastName=$q->param('lastName');
print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if(validarRegistro($userName)==0){
  my $user='alumno';
  my $pass='pweb1';
  my $dsn="DBI:MariaDB:database=pweb1;host=localhost";
  my $dbh=DBI->connect($dsn,$user,$pass) or die ("No se pudo conectar!");
 my $sth=$dbh->prepare("INSERT INTO Users(userName, password, lastName,firstName) VALUES (?,?,?,?)");
  $sth->execute($userName,$password,$lastName,$firstName);
  $dbh->disconnect;

  print "<user>\n";
  print "<owner>$userName</owner>\n";
  print "<firstName>$firstName<firstName>\n";
  print "<lastName>$lastName</lastName>\n";
  print "</user>\n";
}
else {
  print "<user>\n</user>\n";
}

sub validarRegistro{
  my $userName=$_[0];
  my $user='alumno';
  my $password='pweb1';
  my $dsn='DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh=DBI->connect($dsn,$user,$password) or die ("No se pudo conectar!");
  my $sth=$dbh->prepare("SELECT * FROM Users WHERE userName=?");
  $sth->execute($userName);
  my @row=$sth->fetchrow_array;
  $sth->finish;
  return @row;
}
