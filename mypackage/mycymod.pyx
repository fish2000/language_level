#!/usr/bin/env cython
# distutils: language = c++
from array import array

import cython
cimport cython

from libc.stdint cimport *
from libcpp.string cimport string

from ext.halide.mycppwrappers cimport Outputs as HalOutputs

cdef inline bytes u8encode(object source):
    return bytes(source, encoding='UTF-8')

cpdef bytes u8bytes(object source):
    """ Custom version of u8bytes(…) for use in Cython extensions: """
    if type(source) is bytes:
        return source
    elif type(source) is str:
        return u8encode(source)
    elif type(source) is unicode:
        return u8encode(source)
    elif type(source) is int:
        return u8encode(str(source))
    elif type(source) is long:
        return u8encode(str(source))
    elif type(source) is float:
        return u8encode(str(source))
    elif type(source) is bool:
        return source and b'True' or b'False'
    elif type(source) is type(None):
        return b'None'
    elif type(source) is array:
        return bytes(source)
    elif type(source) is memoryview:
        return bytes(source)
    if hasattr(source, '__fspath__'):
        return u8encode(source.__fspath__())
    elif hasattr(source, '__str__'):
        return u8encode(str(source))
    elif hasattr(source, '__bytes__'):
        return bytes(source)
    elif hasattr(source, '__unicode__'):
        return u8encode(unicode(source))
    elif hasattr(source, '__bool__'):
        return bool(source) and b'True' or b'False'
    return bytes(source)

cpdef str u8str(object source):
    """ Custom version of u8str(…) for use in Cython extensions: """
    return u8bytes(source).decode('UTF-8')

def stringify(object instance not None,
              object fields not None):
    """ Custom version of stringify(instance, fields) for use in Cython extensions: """
    field_dict = {}
    for field in fields:
        field_value = getattr(instance, field, b"")
        if field_value:
            field_dict.update({ field : field_value })
    field_dict_items = []
    for k, v in field_dict.items():
        field_dict_items.append(b'''%s="%s"''' % (u8bytes(k),
                                                  u8bytes(v)))
    return b"%s(%s) @ %s" % (u8encode(type(instance).__name__),
                             b", ".join(field_dict_items),
                             u8encode(hex(id(instance))))


@cython.freelist(32)
cdef class Outputs:
    """ Cython wrapper class for Halide::Outputs """
    
    cdef:
        HalOutputs __this__
    
    @classmethod
    def check(cls, instance):
        return getattr(instance, '__class__', None) is cls
    
    def __cinit__(self, *args, **kwargs):
        for arg in args:
            if type(arg) is type(self):
                self.__this__ = self.__this__.object(arg.object_name) \
                                             .assembly(arg.assembly_name) \
                                             .bitcode(arg.bitcode_name) \
                                             .llvm_assembly(arg.llvm_assembly_name) \
                                             .c_header(arg.c_header_name) \
                                             .c_source(arg.c_source_name) \
                                             .python_extension(arg.python_extension_name) \
                                             .stmt(arg.stmt_name) \
                                             .stmt_html(arg.stmt_html_name) \
                                             .static_library(arg.static_library_name) \
                                             .schedule(arg.schedule_name)
                return
        
        object_name = kwargs.pop('object_name', '')
        assembly_name = kwargs.pop('assembly_name', '')
        bitcode_name = kwargs.pop('bitcode_name', '')
        llvm_assembly_name = kwargs.pop('llvm_assembly_name', '')
        c_header_name = kwargs.pop('c_header_name', '')
        c_source_name = kwargs.pop('c_source_name', '')
        python_extension_name = kwargs.pop('python_extension_name', '')
        stmt_name = kwargs.pop('stmt_name', '')
        stmt_html_name = kwargs.pop('stmt_html_name', '')
        static_library_name = kwargs.pop('static_library_name', '')
        schedule_name = kwargs.pop('schedule_name', '')
        
        self.__this__.object_name = <string>u8bytes(object_name)
        self.__this__.assembly_name = <string>u8bytes(assembly_name)
        self.__this__.bitcode_name = <string>u8bytes(bitcode_name)
        self.__this__.llvm_assembly_name = <string>u8bytes(llvm_assembly_name)
        self.__this__.c_header_name = <string>u8bytes(c_header_name)
        self.__this__.c_source_name = <string>u8bytes(c_source_name)
        self.__this__.python_extension_name = <string>u8bytes(python_extension_name)
        self.__this__.stmt_name = <string>u8bytes(stmt_name)
        self.__this__.stmt_html_name = <string>u8bytes(stmt_html_name)
        self.__this__.static_library_name = <string>u8bytes(static_library_name)
        self.__this__.schedule_name = <string>u8bytes(schedule_name)
    
    @property
    def object_name(self):
        return <string>self.__this__.object_name
    @object_name.setter
    def object_name(self, object value not None):
        self.__this__.object_name = <string>u8bytes(value)
    
    @property
    def assembly_name(self):
        return <string>self.__this__.assembly_name
    @assembly_name.setter
    def assembly_name(self, object value not None):
        self.__this__.assembly_name = <string>u8bytes(value)
    
    @property
    def bitcode_name(self):
        return <string>self.__this__.bitcode_name
    @bitcode_name.setter
    def bitcode_name(self, object value not None):
        self.__this__.bitcode_name = <string>u8bytes(value)
    
    @property
    def llvm_assembly_name(self):
        return <string>self.__this__.llvm_assembly_name
    @llvm_assembly_name.setter
    def llvm_assembly_name(self, object value not None):
        self.__this__.llvm_assembly_name = <string>u8bytes(value)
    
    @property
    def c_header_name(self):
        return <string>self.__this__.c_header_name
    @c_header_name.setter
    def c_header_name(self, object value not None):
        self.__this__.c_header_name = <string>u8bytes(value)
    
    @property
    def c_source_name(self):
        return <string>self.__this__.c_source_name
    @c_source_name.setter
    def c_source_name(self, object value not None):
        self.__this__.c_source_name = <string>u8bytes(value)
    
    @property
    def python_extension_name(self):
        return <string>self.__this__.python_extension_name
    @python_extension_name.setter
    def python_extension_name(self, object value not None):
        self.__this__.python_extension_name = <string>u8bytes(value)
    
    @property
    def stmt_name(self):
        return <string>self.__this__.stmt_name
    @stmt_name.setter
    def stmt_name(self, object value not None):
        self.__this__.stmt_name = <string>u8bytes(value)
    
    @property
    def stmt_html_name(self):
        return <string>self.__this__.stmt_html_name
    @stmt_html_name.setter
    def stmt_html_name(self, object value not None):
        self.__this__.stmt_html_name = <string>u8bytes(value)
    
    @property
    def static_library_name(self):
        return <string>self.__this__.static_library_name
    @static_library_name.setter
    def static_library_name(self, object value not None):
        self.__this__.static_library_name = <string>u8bytes(value)
    
    @property
    def schedule_name(self):
        return <string>self.__this__.schedule_name
    @schedule_name.setter
    def schedule_name(self, object value not None):
        self.__this__.schedule_name = <string>u8bytes(value)
    
    def object(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.object(u8bytes(s))
        return out
    
    def assembly(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.assembly(u8bytes(s))
        return out
    
    def bitcode(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.bitcode(u8bytes(s))
        return out
    
    def llvm_assembly(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.llvm_assembly(u8bytes(s))
        return out
    
    def c_header(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.c_header(u8bytes(s))
        return out
    
    def c_source(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.c_source(u8bytes(s))
        return out
    
    def python_extension(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.python_extension(u8bytes(s))
        return out
    
    def stmt(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.stmt(u8bytes(s))
        return out
    
    def stmt_html(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.stmt_html(u8bytes(s))
        return out
    
    def static_library(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.static_library(u8bytes(s))
        return out
    
    def schedule(self, object s=None):
        out = Outputs()
        if s is None:
            s = ''
        out.__this__ = self.__this__.schedule(u8bytes(s))
        return out
    
    def to_string(self):
        return stringify(self, ("object_name", "assembly_name", "bitcode_name",
                                "llvm_assembly_name", "c_header_name", "c_source_name",
                                "python_extension_name", "stmt_name", "stmt_html_name",
                                "static_library_name", "schedule_name"))
    
    def __bytes__(self):
        return self.to_string()
    
    def __str__(self):
        return self.to_string().decode('UTF-8')
    
    def __repr__(self):
        return self.to_string().decode('UTF-8')
