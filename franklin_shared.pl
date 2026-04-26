use strict;
use warnings;
use Irssi;

sub logit {
    my ($level, $msg) = @_;
    
    # Fetch settings directly from IRSSI to ensure global consistency
    my $v = Irssi::settings_get_int('franklin_log_verbosity');
    my $f = Irssi::settings_get_str('franklin_log');
    
    return unless $f; # Safeguard if log file is not set
    return if $level > ($v // 0);
    
    if (open(my $fh, '>>', $f)) {
        print $fh time() . ": " . $msg . "\n";
        close($fh);
    }
}

sub validate_settings {
    my $status = 1;

    # --- Automatic Path Normalization ---
    # These settings require a trailing slash for correct concatenation (e.g., $path$file)
    foreach my $s ('franklin_http_location', 'franklin_response_webserver_addr') {
        my $val = Irssi::settings_get_str($s);
        if ($val ne '' && $val !~ m{/$}) {
            $val .= '/';
            Irssi::settings_set_str($s, $val);
            logit(1, "Auto-fixed: Added missing trailing slash to $s");
        }
    }

    # These settings should NOT have a trailing slash because the code uses $path/$file
    my $pdir = Irssi::settings_get_str('franklin_profiles_dir');
    if ($pdir =~ m{/$}) {
        $pdir =~ s{/+$}{};
        Irssi::settings_set_str('franklin_profiles_dir', $pdir);
        logit(1, "Auto-fixed: Removed trailing slash from franklin_profiles_dir for consistency");
    }
    # ------------------------------------

    # 1. API Key Validation (Critical)
    my $api_key = Irssi::settings_get_str('franklin_api_key');
    if ($api_key !~ m/^.{40}$/) {
        Irssi::print("Franklin Error: 'franklin_api_key' must be 40 characters.");
        logit(0, "Validation Failure: Invalid API key length.");
        $status = 0;
    }

    # 2. Path Validation (Critical)
    my $pdir = Irssi::settings_get_str('franklin_profiles_dir');
    if (-d $pdir && !-w $pdir) {
        Irssi::print("Franklin Error: Profiles directory not writable: $pdir");
        logit(0, "Validation Failure: Profiles directory not writable.");
        $status = 0;
    }

    # 3. Logic & Constraints Warnings (Logged)
    if (Irssi::settings_get_int('franklin_hard_limit') > 390) {
        logit(0, "Warn: Hard limit > 390 may cause IRC line splitting.");
    }
    if (Irssi::settings_get_int('franklin_history_length') > 30) {
        logit(0, "Warn: High history length may exceed API context limits.");
    }
    if (Irssi::settings_get_str('franklin_asshat_threshold') <= 6.5) {
        logit(0, "Warn: Low asshat threshold results in high kick sensitivity.");
    }
    if (Irssi::settings_get_int('franklin_token_limit') >= 1000) {
        logit(0, "Warn: High token limit may result in API errors.");
    }

    # 4. Environment Awareness Warning
    if (!Irssi::settings_get_str('franklin_server_info')) {
        Irssi::print("Franklin Warning: Set 'franklin_server_info' for better AI immersion.");
    }

    return $status;
}

1;