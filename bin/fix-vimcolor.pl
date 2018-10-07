#!/usr/bin/env perl

use strict;
use warnings;
use Path::Tiny qw/ path /;

path(shift)->edit_utf8(
    sub {
s#<html>#<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">#ms;
        s#^( *)<style>$#$1<style>#ms;
        s#\A#<?xml version="1.0" encoding="utf-8"?>#;
        s#(<!DOCTYPE html)[^>]+(>)#$1$2#;
    }
);
