use strict;
use Cache::Memcached::AnyEvent;

#my $memd_anyevent = Cache::Memcached::AnyEvent->new(
#    servers => [ '127.0.0.1:11211' ],
#    namespace => join('.', time(), $$, rand(), ''),
#);
my $memd_anyevent_bin = Cache::Memcached::AnyEvent->new(
    servers => [ '127.0.0.1:11211', '127.0.0.1:11212' ],
    namespace => join('.', time(), $$, rand(), ''),
    protocol_class => 'Binary',
);

#for (1..5000) {
#    my $cv = AE::cv;
#    $memd_anyevent->get_multi([ 'a'..'z' ], sub {
#        $cv->send
#    } );
#    $cv->recv;
#}

my $cv = AE::cv;
for (1..5000) {
    $cv->begin;
    $memd_anyevent_bin->get_multi([ 'a'..'z' ], sub {
        $cv->end
    } );
}
$cv->recv;
