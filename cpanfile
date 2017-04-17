requires 'perl', '5.24.0';
requires "TAP::Harness" => "0";

requires "Dancer2" => "0.203000";
requires "Template" => "0";
requires "DateTime::Format::DateParse" => "0";
requires "DateTime::Format::SQLite" => "0";
requires "DBD::SQLite" => "0";
requires "Net::Twitter" => "0";

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};
