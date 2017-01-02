# vim-headerguard
Add header guards to C/C++ header files.

It is a common practice to insert header guards into C/C++ header files to
allow a header to be included multiple times.  A header guard for file
HeaderName.h typically looks something like this::

  #ifndef HEADERNAME_H
  #define HEADERNAME_H
    ...header content...
  #endif /* HEADERNAME_H */

This plugin inserts header guard when new .h or .hpp file is created.
