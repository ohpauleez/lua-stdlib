# Local Make rules.
#
# Copyright (C) 2013-2014 Gary V. Vaughan
# Written by Gary V. Vaughan, 2013
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


## ------------ ##
## Environment. ##
## ------------ ##

std_path = $(abs_srcdir)/lib/?.lua
LUA_ENV  = LUA_PATH="$(std_path);$(LUA_PATH)"


## ---------- ##
## Bootstrap. ##
## ---------- ##

old_NEWS_hash = 7ef01dfb840329db3d8db218bfe9d075

update_copyright_env = \
	UPDATE_COPYRIGHT_HOLDER='(Gary V. Vaughan|Reuben Thomas)' \
	UPDATE_COPYRIGHT_USE_INTERVALS=1 \
	UPDATE_COPYRIGHT_FORCE=1


## ------------- ##
## Declarations. ##
## ------------- ##

filesdir		= $(docdir)/files
modulesdir		= $(docdir)/modules

dist_doc_DATA		=
dist_files_DATA		=
dist_modules_DATA	=

include specs/specs.mk


## ------ ##
## Build. ##
## ------ ##

dist_lua_DATA +=			\
	lib/std.lua			\
	$(NOTHING_ELSE)

luastddir = $(luadir)/std

dist_luastd_DATA =			\
	lib/std/base.lua		\
	lib/std/container.lua		\
	lib/std/debug.lua		\
	lib/std/debug_init.lua		\
	lib/std/functional.lua		\
	lib/std/getopt.lua		\
	lib/std/io.lua			\
	lib/std/list.lua		\
	lib/std/math.lua		\
	lib/std/modules.lua		\
	lib/std/object.lua		\
	lib/std/package.lua		\
	lib/std/set.lua			\
	lib/std/strbuf.lua		\
	lib/std/strict.lua		\
	lib/std/string.lua		\
	lib/std/table.lua		\
	lib/std/tree.lua		\
	$(NOTHING_ELSE)

# In order to avoid regenerating std.lua at configure time, which
# causes the documentation to be rebuilt and hence requires users to
# have ldoc installed, put std/std.lua in as a Makefile dependency.
# (Strictly speaking, distributing an AC_CONFIG_FILE would be wrong.)
lib/std.lua: lib/std.lua.in
	./config.status --file=$@


## Use a builtin rockspec build with root at $(srcdir)/lib
mkrockspecs_args = --module-dir $(srcdir)/lib


## ------------- ##
## Distribution. ##
## ------------- ##

EXTRA_DIST +=				\
	doc/config.ld			\
	lib/std.lua.in			\
	$(NOTHING_ELSE)


## -------------- ##
## Documentation. ##
## -------------- ##

dist_doc_DATA +=			\
	$(srcdir)/doc/index.html	\
	$(srcdir)/doc/ldoc.css

dist_files_DATA += $(wildcard $(srcdir)/lib/files/*.html)
dist_modules_DATA += $(wildcard $(srcdir)/lib/modules/*.html)

$(dist_doc_DATA): $(dist_lua_DATA) $(dist_luastd_DATA)
	cd $(srcdir) && $(LDOC) -c doc/config.ld .
