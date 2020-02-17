#!/usr/bin/env perl
use strict;
use warnings;
use DBI; 

#MYSQL CONFIG VARIABLES
my $host = "localhost";
my $database = "dmseq";
my $user = "root"; #mysql username
my $password = ""; #mysql password, if any

#my $dsn = "DBI:mysql:$database:$host"; 
# connect without database specified
my $dsn = "DBI:mysql:;host=$host";
print "Trying dsn=\"$dsn\"\n";
my $dbh = DBI->connect( $dsn, $user, $password, {RaiseError=>1, PrintError=>0} ) or die $DBI::errstr; 

### itempotent database creation statements
# create dmseq, if it doesn't exist
my $sql = "CREATE DATABASE IF NOT EXISTS $database";
my $stm = $dbh->prepare($sql);
$stm->execute();

$sql = "use $database";
$stm = $dbh->prepare($sql);
$stm->execute();

# create main table
my $tablename = "testtable";
$sql="CREATE TABLE IF NOT EXISTS $tablename (experiment VARCHAR(20), 
                                             time INT DEFAULT 0,
                                             chr varchar(10), 
                                             coord INT DEFAULT 0,
                                             Acount INT DEFAULT 0, 
                                             Tcount INT DEFAULT 0, 
                                             Ccount INT DEFAULT 0, 
                                             Gcount INT DEFAULT 0, 
                                             Ncount INT DEFAULT 0, 
                                             totalcount INT DEFAULT 0,
                                             primary key(experiment,time,chr,coord));";
print "Trying sql \"$sql\"\n";
my $sth = $dbh->prepare($sql); 
$sth->execute(); 

#close connection to database so we can reconnect with specific args
$sth->finish();
$dbh->disconnect();

$dsn = "DBI:mysql:$database:$host:mysql_local_infile=1"; 
$dbh = DBI->connect( $dsn, $user, $password, {RaiseError=>1, PrintError=>0} ) or die $DBI::errstr; 

# write a temporary load table to test this operation 
my $datastring = "wt	S2	chr2L	5410	1	0	0	0	0	1
wt	S2	chr2L	5411	1	0	0	0	0	1
wt	S2	chr2L	5412	1	0	0	0	0	1
wt	S2	chr2L	5413	1	0	0	0	0	1
wt	S2	chr2L	5414	0	1	0	0	0	1
wt	S2	chr2L	5415	1	0	0	0	0	1
wt	S2	chr2L	5416	1	0	0	0	0	1
wt	S2	chr2L	5417	1	0	0	0	0	1
wt	S2	chr2L	5418	0	1	0	0	0	1
wt	S2	chr2L	5419	0	1	0	0	0	1
wt	S2	chr2L	5420	0	0	1	0	0	1
wt	S2	chr2L	5421	0	0	1	0	0	1";

my $matrixfile = "test.matrix";
open (OUT,">$matrixfile") or die $!;
print OUT $datastring;
close OUT;

my $actualfile = "../examples/S2_wtRNA_chr2L.sort.sam.matrix.wig";

# test LOCAL INFILE permissions
eval {
    $sql = "LOAD DATA LOCAL INFILE '$actualfile' INTO TABLE $tablename (experiment,time,chr,coord,Acount,Tcount,Ccount,Gcount,Ncount,totalcount)";
    print "$sql\n";
    $sth = $dbh->prepare($sql); 
    $sth->execute;
};

if ($@) {
    print "Error in loading data: $@";
}

unlink $matrixfile;

$sth->finish();
$dbh->disconnect();

print "If you got this far without error messages, then you should be OK.\n";
