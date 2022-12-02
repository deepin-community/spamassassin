#!/usr/bin/perl -T

BEGIN {
  if (-e 't/test_dir') { # if we are running "t/rule_tests.t", kluge around ...
    chdir 't';
  }

  if (-e 'test_dir') {            # running from test directory, not ..
    unshift(@INC, '../blib/lib');
    unshift(@INC, '../lib');
  }
}

use lib '.'; use lib 't';
use SATest; sa_t_init("stop_always_matching_regexps");
use Test::More tests => 12;

# ---------------------------------------------------------------------------

use strict;
require Mail::SpamAssassin;
use Mail::SpamAssassin::Util qw(compile_regexp);

sub is_caught {
  my ($re) = @_;
  my ($rec, $err) = compile_regexp($re, 0, 1);
  return !$rec;
}

ok !is_caught 'foo|bar';
ok is_caught 'foo||bar';
ok is_caught '|bar';
ok is_caught 'foo|';
ok !is_caught 'foo\||bar';
ok !is_caught '\||bar';

ok !is_caught '(foo|bar)baz';
ok is_caught '(foo||bar)baz';
ok !is_caught '(|bar)baz';
ok !is_caught '(foo|)baz';
ok !is_caught '(foo\||bar)baz';
ok !is_caught '(\||bar)baz';

# ok is_caught '(\s*) +';

