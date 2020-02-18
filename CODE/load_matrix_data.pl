#!/usr/bin/env perl
use strict;
use warnings;
use DBI; 
use Getopt::Std;

#Author Reazur Rahman 2014
# load the data in *.matrix file into database table

my $USAGE = "load_matrix_data.pl -t tablename -d datafile\n";
my %option;
getopts( 't:d:h', \%option );
my ($tablename, $matrixfile);
if ( $option{t} &&  $option{d} ) {
    $tablename = $option{t};
    $matrixfile = $option{d};
} else {
    die "proper parameters not passed\n$USAGE";
}

#MYSQL CONFIG VARIABLES
my $host = "localhost";
my $database = "dmseq";
my $user = "root"; #mysql username
my $password = ""; #mysql password, if any
#my $password = "password"; #mysql password, if any

# connect to the mysql database
my $dsn = "DBI:mysql:$database:$host"; 
my $dbh = DBI->connect( $dsn, $user, $password, {RaiseError=>1, PrintError=>0} ) or die $DBI::errstr; 

my ($sth);
#create the table
eval {
    $sth = $dbh->prepare("CREATE TABLE $tablename (experiment VARCHAR(20), 
                                                        time INT NOT NULL, 
                                                           chr varchar(10), 
                                                        coord INT DEFAULT 0, 
                                                       Acount INT DEFAULT 0, 
                                                       Tcount INT DEFAULT 0, 
                                                       Ccount INT DEFAULT 0, 
                                                       Gcount INT DEFAULT 0, 
                                                       Ncount INT DEFAULT 0, 
                                                   totalcount INT DEFAULT 0, 
                                   primary key(experiment,time,chr,coord))");
    $sth->execute; 
};

if ($@) {
    if ($@=~/already exists/) {
	#no need to printt the error message if it the table already exists error
    } else {
	# else print the error message
	print "Error in database creation: $@";
    }
}

#load the table
eval {
    $sth = $dbh->prepare("LOAD DATA LOCAL INFILE '$matrixfile' INTO TABLE $tablename (experiment,time,chr,coord,Acount,Tcount,Ccount,Gcount,Ncount,totalcount)"); 
    $sth->execute;
};

if ($@) {
    print "Error in loading data: $@";
}

#show table data
#$sth = $dbh->prepare( "show tables" ); 
#$sth->execute; 
#while ( my @result = $sth->fetchrow_array ) { 
#	print "@result\n"; 
#} 


#close connection to database
$sth->finish; 
$dbh->disconnect;
