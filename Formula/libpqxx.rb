class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "http://pqxx.org/download/software/libpqxx/libpqxx-4.0.1.tar.gz"
  sha256 "097ceda2797761ce517faa5bee186c883df1c407cb2aada613a16773afeedc38"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4510d02d679143af2c19b7982fa977b9b35da5e5dacf073d1e7cecab8730a54f" => :sierra
    sha256 "5bda2a641ddb2774efa2355612181d6cbdaae5dd665eeac656ff4d42b90cfbdb" => :el_capitan
    sha256 "7e3ee6966db26936ca065024fbf5ef1476317c8ffdeaafe4f43e6d6252ca6061" => :yosemite
    sha256 "e93fe321d641627928110a05d2f985b4b3f08a6a015c9e9846a3aaf25286555a" => :mavericks
    sha256 "602109e64f4d6e94f81b43fad6f2bb999c497d32214942aa1fe5c68f25960628" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :postgresql

  # Patches borrowed from MacPorts. See:
  # https://trac.macports.org/ticket/33671
  #
  # (1) Patched maketemporary to avoid an error message about improper use
  #     of the mktemp command; apparently maketemporary is designed to call
  #     mktemp in various ways, some of which may be improper, as it attempts
  #     to determine how to use it properly; we don't want to see those errors
  #     in the configure phase output.
  # (2) Patched configure on darwin to fix incorrect assumption
  #     that true and false always live in /bin; on macOS they live in /usr/bin.
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end
end

__END__
--- a/tools/maketemporary.orig	2009-07-04 00:38:30.000000000 -0500
+++ b/tools/maketemporary	2012-03-18 01:13:26.000000000 -0500
@@ -5,7 +5,7 @@
 TMPDIR="${TMPDIR:-/tmp}"
 export TMPDIR

-T="`mktemp`"
+T="`mktemp 2>/dev/null`"
 if test -z "$T" ; then
	T="`mktemp -t pqxx.XXXXXX`"
 fi
--- a/configure.orig	2011-11-27 05:12:25.000000000 -0600
+++ b/configure	2012-03-18 01:09:08.000000000 -0500
@@ -15204,7 +15204,7 @@
 fi


- if /bin/true; then
+ if /usr/bin/true; then
   BUILD_REFERENCE_TRUE=
   BUILD_REFERENCE_FALSE='#'
 else
@@ -15290,7 +15290,7 @@
 fi


- if /bin/true; then
+ if /usr/bin/true; then
   BUILD_TUTORIAL_TRUE=
   BUILD_TUTORIAL_FALSE='#'
 else
@@ -15299,7 +15299,7 @@
 fi

 else
- if /bin/false; then
+ if /usr/bin/false; then
   BUILD_REFERENCE_TRUE=
   BUILD_REFERENCE_FALSE='#'
 else
@@ -15307,7 +15307,7 @@
   BUILD_REFERENCE_FALSE=
 fi

- if /bin/false; then
+ if /usr/bin/false; then
   BUILD_TUTORIAL_TRUE=
   BUILD_TUTORIAL_FALSE='#'
 else
