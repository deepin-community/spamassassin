#!/usr/bin/perl -T

use lib '.'; use lib 't';
use SATest; sa_t_init("if_can");
use Test::More tests => 16;

# ---------------------------------------------------------------------------

%patterns = (

        q{ GTUBE }, 'gtube',
        q{ SHOULD_BE_CALLED1 }, 'should_be_called1',
        q{ SHOULD_BE_CALLED2 }, 'should_be_called2',
        q{ SHOULD_BE_CALLED3 }, 'should_be_called3',
        q{ SHOULD_BE_CALLED4 }, 'should_be_called4',
        q{ SHOULD_BE_CALLED5 }, 'should_be_called5',
        q{ SHOULD_BE_CALLED6 }, 'should_be_called6',
        q{ SHOULD_BE_CALLED7 }, 'should_be_called7',
        q{ SHOULD_BE_CALLED8 }, 'should_be_called8',
        q{ SHOULD_BE_CALLED9 }, 'should_be_called9',
        q{ SHOULD_BE_CALLED10 }, 'should_be_called10',

);
%anti_patterns = (

        q{ SHOULD_NOT_BE_CALLED1 }, 'should_not_be_called1',
        q{ SHOULD_NOT_BE_CALLED2 }, 'should_not_be_called2',
        q{ SHOULD_NOT_BE_CALLED3 }, 'should_not_be_called3',
        q{ SHOULD_NOT_BE_CALLED4 }, 'should_not_be_called4',

);
tstlocalrules (q{

        loadplugin Mail::SpamAssassin::Plugin::Test

        if (has(Mail::SpamAssassin::Plugin::Test::check_test_plugin))
          body SHOULD_BE_CALLED1 /./
        endif
        if (has(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_true))
          body SHOULD_BE_CALLED2 /./
        endif
        if (has(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_false))
          body SHOULD_BE_CALLED3 /./
        endif
        if (can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_true))
          body SHOULD_BE_CALLED4 /./
        endif
        if (!can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_false))
          body SHOULD_BE_CALLED5 /./
        endif
        if (!has(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_nosuch))
          body SHOULD_BE_CALLED6 /./
        endif
        if (!can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_nosuch))
          body SHOULD_BE_CALLED7 /./
        endif
        if can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_true) && version > 0.00000
          body SHOULD_BE_CALLED8 /./
        endif
        if !can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_false  ) && !(! version > 0.00000)
          body SHOULD_BE_CALLED9 /./
        endif
        if has(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_true) && (!can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_nosuch))
          body SHOULD_BE_CALLED10 /./
        endif

        if !has(Mail::SpamAssassin::Plugin::Test::check_test_plugin)
          body SHOULD_NOT_BE_CALLED1 /./
        endif
        if (has(Mail::SpamAssassin::Plugin::Test::non_existent_method))
          body SHOULD_NOT_BE_CALLED2 /./
        endif
        if (can(Mail::SpamAssassin::Plugin::Test::non_existent_method))
          body SHOULD_NOT_BE_CALLED3 /./
        endif
        if (can(Mail::SpamAssassin::Plugin::Test::test_feature_xxxx_false))
          body SHOULD_NOT_BE_CALLED4 /./
        endif

});

ok (sarun ("-L -t < data/spam/gtube.eml", \&patterns_run_cb));
ok_all_patterns();

