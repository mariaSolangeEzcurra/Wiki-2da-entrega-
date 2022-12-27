#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q=CGI->new;
my $userName=$q->param('userName');
my $password=$q->param('password');

print $q->header('text/XML)';
print "<?xml version='1.0' encoding='utf-8'?>\n";

if(verificarLogin($userName,$password)){
  my $user='alumno';
  my $pass='pweb1';
  my $dsn='DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh=DBI->connect($dsn,$user,$pass) or die ("No se pudo conectar!");

my $sth=$dbh->prepare("SELECT firstName FROM Users WHERE userName=? AND password=?");
$sth->execute($userName,$password);
my @row=$sth->fetchrow_array;

$sth=$dbh->prepare("SELECT lastName FROM Users WHERE userName=? AND password=?");
$sth->execute($userName, $password);
my @row1 = $sth->fetchrow_array;

$sth->finish;
$dbh->disconnect;

print "<user>\n";
print "<owner>$userName</owner>\n";
print "<firstName>$row[0]</firstName>\n";
print "<lastName>$row1[0]</lastName>\n";
print "</user>\n";
}
else{
  print "<user>\n</user>\n";
}

sub verificarLogin{
  my $userName=$_[0];
  my $password=$_[1];

  my $user='alumno';
  my $pass='pweb1';
  my $dsn='DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh =DBI->connect($dsn,$user,$pass) or die ("No se pudo conectar!");
  my $sth=$dbh->prepare("SELECT * FROM Users WHERE userName=? AND password=?");
  $sth->execute($userName,$password);
  my @row=$sth->fetchrow_array;

  $sth->finish;
  $dbh->disconnect;
  return @row;
}
