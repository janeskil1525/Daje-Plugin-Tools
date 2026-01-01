package Daje::Document::Templates::Tools::Generate::Angular;
use Mojo::Base 'Daje::Document::Templates::Base', -base;
use v5.42;

# NAME
# ====
#
# Daje::Templates::Tools::Generate::Angular; - It creates Angular code
#
# SYNOPSIS
# ========
#
#     use Daje::Templates::Tools::Generate::Angular;
#
#     Provides a method for the template to be loaded into the data structure
#
#     sub length_default_calc($self) returns a sub for setting details in template.
#
#
# DESCRIPTION
# ===========
#
# Daje::Templates::Tools::Generate::Angular; is a module that retrieves data from a View
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#

sub set_subs($self) {
    $self->subs('set_datatype');
}

sub set_datatype($datatype) {
    my $result = "string";
    if(uc($datatype) eq 'BIGINT') {
        $result = 'numeric';
    } elsif(uc($datatype) eq 'NUMERIC') {
        $result = 'numeric';
    } elsif(uc($datatype) eq 'BOOLEAN') {
        $result = 'boolean';
    } elsif(uc($datatype) eq 'MONEY') {
        $result = 'numeric';
    }

    return $result;
}
1;

__DATA__

@@ interface

import{ ResponseBase } from '../../../core/response/response.interface';

export interface [%- class_name -%]Interface extends ResponseBase {
    [% project_name -%]_[%- table.table_name -%]_pkey:number,
    [%- FOREACH field IN fields -%]
    [%- IF field.foreign_key %]
    [%- project_name -%]_[%- field.fieldname %]_fkey:number[% "," IF loop.last() == 0 %]
    [%- ELSE %]
    [% field.fieldname %]:[% set_datatype(field.datatype) %][% "," IF loop.last() == 0 %]
    [%- END -%]
    [% END %]
};

@@ component

import { Component, inject } from '@angular/core';
import { ActivatedRoute } from "@angular/router";


@Component({
  selector: 'p-[% project_name -%]-[%- table.table_name -%]',
  imports: [

  ],
  templateUrl: './table.object.index.component.html',
  styleUrl: './table.object.index.component.css',
  standalone: true,
})