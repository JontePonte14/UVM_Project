#include <Python.h>
#include <stdio.h>
#include <dlfcn.h>
#include <libgen.h>
#include <limits.h>
#include <string.h>

static int python_initialized = 0;
static PyObject *pModule = NULL;
static PyObject *pFunc = NULL;

extern "C" void execute_stage_ref(
    int data1, int data2, int immediate_data, 
    int compflg_in, int alu_op, int alu_src, int encoding,
    int* alu_data, int* memory_data, int* overflow_flag, int* compflg_out
){
    // Initialize Python ONCE
    if (!python_initialized) {

    Py_Initialize();

    PyRun_SimpleString(
        "import sys\n"
        "sys.stderr = sys.stdout\n"
    );

    Dl_info info;
    char so_path[PATH_MAX];
    char py_path[PATH_MAX];

    if (dladdr((void*)execute_stage_ref, &info) == 0) {
        printf("ERROR: dladdr failed\n");
        return;
    }

    strncpy(so_path, info.dli_fname, PATH_MAX);
    char *so_dir = dirname(so_path);
    snprintf(py_path, PATH_MAX, "%s/../reference_model", so_dir);

    PyList_Append(
        PySys_GetObject((char*)"path"),
        PyUnicode_DecodeFSDefault(py_path)
    );

    pModule = PyImport_ImportModule("execute_stage_ref");
    if (!pModule) {
        printf("ERROR: Failed to import execute_stage_ref\n");
        PyErr_Print();
        return;
    }

    pFunc = PyObject_GetAttrString(pModule, "execute_stage_ref");
    if (!pFunc || !PyCallable_Check(pFunc)) {
        printf("ERROR: execute_stage_ref not callable\n");
        PyErr_Print();
        return;
    }

    python_initialized = 1;
}

    // Build argument tuple
    PyObject *pArgs = Py_BuildValue("(iiiiiii)",
        data1, data2, immediate_data,
        compflg_in, alu_op, alu_src, encoding
    );

    PyObject *pRet = PyObject_CallObject(pFunc, pArgs);
    Py_DECREF(pArgs);

    if (!pRet) {
        printf("Python call failed!\n");
        PyErr_Print();
        return;
    }

    // Extract return tuple
    *alu_data     = PyLong_AsLong(PyTuple_GetItem(pRet, 0));
    *memory_data  = PyLong_AsLong(PyTuple_GetItem(pRet, 1));
    *overflow_flag= PyLong_AsLong(PyTuple_GetItem(pRet, 2));
    *compflg_out  = PyLong_AsLong(PyTuple_GetItem(pRet, 3));

    Py_DECREF(pRet);
}
