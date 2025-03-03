#!/bin/bash

# Compile

BIN_NAME=${CM_BIN_NAME:-run.out}
RUN_DIR=${CM_RUN_DIR:-.}

echo "RUN_DIR=$RUN_DIR"
rm -f ${RUN_DIR}/${BIN_NAME}

if [ -z "${CM_SOURCE_FOLDER_PATH}" ]; then
  echo "No source directory (CM_SOURCE_FOLDER_PATH} specified"
  exit 1
fi

if [[ -z "${CM_C_SOURCE_FILES}"  && -z "${CM_CXX_SOURCE_FILES}" && -z "${CM_F_SOURCE_FILES}" ]]; then
  echo "No source files (CM_C_SOURCE_FILES or CM_CXX_SOURCE_FILES or CM_F_SOURCE_FILES) specified"
  exit 1
fi

echo ""
echo "Checking compiler version ..."
echo ""

${CM_C_COMPILER_WITH_PATH} --version

echo ""
echo "Compiling source files ..."
echo ""

cd ${CM_SOURCE_FOLDER_PATH}
test $? -eq 0 || exit 1

IFS=';' read -ra FILES <<< "${CM_C_SOURCE_FILES}"
for file in "${FILES[@]}"; do
  base_name=${file%.*}
  CMD="${CM_C_COMPILER_WITH_PATH} -c ${CM_C_COMPILER_FLAGS} ${CM_C_INCLUDE_PATH} $file -o $base_name.o"
  echo $CMD
  eval $CMD
  test $? -eq 0 || exit 1
done

IFS=';' read -ra FILES <<< "${CM_CXX_SOURCE_FILES}"
for file in "${FILES[@]}"; do
  base_name=${file%.*}
  CMD="${CM_CXX_COMPILER_WITH_PATH} -c ${CM_CXX_COMPILER_FLAGS} ${CM_CPLUS_INCLUDE_PATH} $file -o $base_name.o"
  echo $CMD
  eval $CMD
  test $? -eq 0 || exit 1
done


echo ""
echo "Linking ..."
echo ""
CMD="${CM_LINKER_WITH_PATH} ${CM_LINKER_COMPILE_FLAGS}  *.o -o ${RUN_DIR}/${BIN_NAME} ${CM_LD_LIBRARY_PATH} ${CM_LINKER_FLAGS}"
echo $CMD
eval $CMD

test $? -eq 0 || exit 1
