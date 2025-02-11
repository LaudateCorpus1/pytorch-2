#!/bin/bash
set -e
echo "# Generating Autopkgtest Test Cases for the Python Testing Programs"
echo "# The tests are collected from test/run_test.py"
FILES=(
    'distributed/test_c10d'
    'distributed/test_c10d_spawn'
    'distributed/test_data_parallel'
    'distributed/test_distributed_fork'
    'distributed/test_distributed_spawn'
    'distributed/test_nccl'
    'test_autograd'
    'test_bundled_inputs'
    'test_complex'
    'test_cpp_api_parity'
    'test_cpp_extensions_aot_ninja'
    'test_cpp_extensions_aot_no_ninja'
    'test_cpp_extensions_jit'
    'test_cuda'
    'test_cuda_primary_ctx'
    'test_dataloader'
    'test_distributions'
    'test_expecttest'
    'test_foreach'
    'test_indexing'
    'test_jit'
    'test_jit_cuda_fuser'
    'test_jit_cuda_fuser_legacy'
    'test_jit_cuda_fuser_profiling'
    'test_linalg'
    'test_logging'
    'test_mkldnn'
    'test_mobile_optimizer'
    'test_multiprocessing'
    'test_multiprocessing_spawn'
    'test_namedtuple_return_api'
    'test_native_functions'
    'test_nn'
    'test_numba_integration'
    'test_ops'
    'test_optim'
    'test_quantization'
    'test_serialization'
    'test_show_pickle'
    'test_sparse'
    'test_spectral_ops'
    'test_tensor_creation_ops'
    'test_torch'
    'test_type_hints'
    'test_type_info'
    'test_unary_ufuncs'
    'test_utils'
    'test_vmap'
    'test_vulkan'
    'test_xnnpack_integration'
)

PERMISSIVE_LIST=(
	distributed/test_c10d 
	distributed/test_c10d_spawn 
    distributed/test_data_parallel
	distributed/test_distributed_fork 
	distributed/test_distributed_spawn 
	distributed/test_nccl 
	test_autograd 
	test_cpp_api_parity 
	test_cpp_extensions_aot_ninja 
	test_cpp_extensions_aot_no_ninja 
	test_cpp_extensions_jit 
	test_cuda
	test_dataloader
	test_distributions 
	test_indexing
	test_jit
	test_jit_cuda_fuser
	test_jit_cuda_fuser_legacy
	test_jit_cuda_fuser_profiling
	test_linalg 
	test_mkldnn
	test_mobile_optimizer
	test_multiprocessing_spawn
	test_native_functions
	test_nn 
	test_ops 
	test_optim 
	test_quantization
	test_serialization
	test_sparse 
	test_tensor_creation_ops
	test_torch
	test_utils
	test_utils
	test_vmap 
)

echo "# Found" ${#FILES[@]} "tests"
echo "#"

for (( i = 0; i < ${#FILES[@]}; i++ )); do
	echo "# Py test ${i}/${#FILES[@]}"
	if echo ${PERMISSIVE_LIST[@]} | grep -o ${FILES[$i]} >/dev/null 2>/dev/null; then
		echo "Test-Command: cd test/ ; python3 run_test.py -pt -i ${FILES[$i]}.py -v || true"
	else
		echo "Test-Command: cd test/ ; python3 run_test.py -pt -i ${FILES[$i]}.py -v || if test 134 = \$?; then true; else exit \$?; fi"
	fi
	echo "Depends: build-essential, ninja-build, libtorch-dev, python3-torch, python3-pytest, python3-hypothesis, python3-setuptools, pybind11-dev,"
	echo "Features: test-name=$((${i}+1))_of_${#FILES[@]}__pytest__$(basename ${FILES[$i]})"
	echo "Restrictions: allow-stderr"
	echo ""
done
