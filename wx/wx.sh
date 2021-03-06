#!/bin/sh

# Input
#
# wx.swift
# wx_const.swift
# wxc_wrapper.swift
# wxwidgets_patch.cpp
# libwxC.a
# libraries of wxWidgets-3.0.3

# Output
#
# wx.swiftmodule
# wx.swiftdoc
# libwx.dll

export WORK_DIR=c:/projects
export SWIFT_BIN=$WORK_DIR/build/NinjaMinGW/swift/bin
export WXWIDGETS_LIBDIR=$WORK_DIR/wxWidgets-3.0.3/lib/gcc510TDM_x64_dll
export CCC=c:/mingw64/bin/clang++

echo "Generating wx.swiftmodule"
$SWIFT_BIN/swiftc -emit-module wx.swift wx_const.swift wxc_wrapper.swift -module-name wx -module-link-name wx -O -parse-as-library
if [ "X$?" != "X0" ]
then
  exit 1
fi

echo "Compiling wx.swift"
$SWIFT_BIN/swiftc -c -module-name wx -O -parse-as-library -force-single-frontend-invocation -o wx.o wx.swift wx_const.swift wxc_wrapper.swift

echo "Compiling wxwidgets_patch.cpp"
$CCC -c wxwidgets_patch.cpp

echo "Building libwx.dll"
$CCC -shared -o libwx.dll wx.o wxwidgets_patch.o -L$SWIFT_BIN/../lib/swift/mingw -lswiftCore -L C:/Work/wxSwift/wxc/build/cpp -lwxC -Wl,--out-implib,libwx.dll.a  -L $WXWIDGETS_LIBDIR -lwxbase30u -lwxbase30u_net -lwxbase30u_xml -lwxexpat -lwxjpeg -lwxmsw30u_adv -lwxmsw30u_aui -lwxmsw30u_core -lwxmsw30u_gl -lwxmsw30u_html -lwxmsw30u_media -lwxmsw30u_propgrid -lwxmsw30u_ribbon -lwxmsw30u_richtext -lwxmsw30u_stc -lwxmsw30u_webview -lwxmsw30u_xrc -lwxpng -lwxregexu -lwxscintilla -lwxtiff -lwxzlib -lShlwapi -Xlinker --allow-multiple-definition

echo "Installing"
mv wx.swiftmodule wx.swiftdoc libwx.dll.a $SWIFT_BIN/../lib/swift/mingw/x86_64
mv libwx.dll $SWIFT_BIN/../lib/swift/mingw

echo 
echo "RUN swift test_wx1.swift"
echo " or swift test_wx2.swift"

