#!/usr/bin/perl
    use strict;
    use Time::HiRes qw(usleep nanosleep);

my $process_name = "$ARGV[0]";
my $deluge_id = `ps -ww -C $process_name -o pid --no-header|perl -pe 's/ //g'`;
chomp($deluge_id);
my $totalcmd = "head -n 1 /proc/stat|awk '{print \$2+\$3+\$4+\$5+\$6+\$7+\$8}'";
my $delugecmd = "awk '{print \$14+\$15}' /proc/$deluge_id/stat";
my $deluge_jiffies = `$delugecmd`;
my $total_jiffies = `$totalcmd`;
my $deluge_jiffies_old = 0;
my $total_jiffies_old = 0;
my $pcpu = 0;
my $sleeptime = 1000000*3;#second number is seconds
if($#ARGV+1 > 1){$sleeptime = 1000000*$ARGV[1];}
my $maxiter = 1;
if($#ARGV+1 > 2){$maxiter = $ARGV[2];}
my $curriter = 0;
while ( $maxiter < 0 || $curriter < $maxiter)
{
    $deluge_jiffies_old = $deluge_jiffies;
    $total_jiffies_old =        $total_jiffies;
    usleep($sleeptime);
    $deluge_id = `ps -ww -C $process_name -o pid --no-header|perl -pe 's/ //g'`;
    chomp($deluge_id);
    $deluge_jiffies = `$delugecmd`;
    $total_jiffies = `$totalcmd`;
    $pcpu = 100*       ($deluge_jiffies - $deluge_jiffies_old)/($total_jiffies - $total_jiffies_old + 1);
    #print "\%cpu = $pcpu\n";
    print "$pcpu\n";
    $curriter++;
}
exit(0);
