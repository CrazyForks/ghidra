#!/usr/bin/env bash
## ###
# IP: GHIDRA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
#@title qemu + gdb
#@image-opt arg:1
#@desc <html><body width="300px">
#@desc   <h3>Launch with <tt>qemu</tt> and connect with <tt>gdb</tt></h3>
#@desc   <p>
#@desc     This will launch the target on the local machine using <tt>qemu</tt>.
#@desc     Then in a second terminal, it will connect <tt>gdb</tt> to QEMU's GDBstub.
#@desc     For setup instructions, press <b>F1</b>.
#@desc   </p>
#@desc </body></html>
#@menu-group cross
#@icon icon.debugger
#@help gdb#qemu
#@enum Endian:str auto big little
#@arg :file! "Image" "The target binary executable image"
#@args "Arguments" "Command-line arguments to pass to the target"
#@env GHIDRA_LANG_EXTTOOL_qemu:file="" "QEMU command" "The path to qemu for the target architecture."
#@env QEMU_GDB:int=1234 "QEMU Port" "Port for gdb connection to qemu"
#@env OPT_EXTRA_QEMU_ARGS:str="" "Extra qemu arguments" "Extra arguments to pass to qemu. Use with care."
#@env OPT_GDB_PATH:file="gdb-multiarch" "gdb command" "The path to gdb. Omit the full path to resolve using the system PATH."
#@env OPT_ARCH:str="auto" "Architecture" "Target architecture"
#@env OPT_ENDIAN:Endian="auto" "Endian" "Target byte order"
#@env OPT_EXTRA_TTY:bool=false "QEMU TTY" "Provide a separate terminal emulator for the target."
#@env OPT_PULL_ALL_SECTIONS:bool=false "Pull all section mappings" "Force gdb to send all mappings to Ghidra. This can be costly (see help)."
#@tty TTY_TARGET if env:OPT_EXTRA_TTY

if [ -d ${GHIDRA_HOME}/ghidra/.git ]
then
  export PYTHONPATH=$GHIDRA_HOME/ghidra/Ghidra/Debug/Debugger-agent-gdb/build/pypkg/src:$PYTHONPATH
  export PYTHONPATH=$GHIDRA_HOME/ghidra/Ghidra/Debug/Debugger-rmi-trace/build/pypkg/src:$PYTHONPATH
elif [ -d ${GHIDRA_HOME}/.git ]
then 
  export PYTHONPATH=$GHIDRA_HOME/Ghidra/Debug/Debugger-agent-gdb/build/pypkg/src:$PYTHONPATH
  export PYTHONPATH=$GHIDRA_HOME/Ghidra/Debug/Debugger-rmi-trace/build/pypkg/src:$PYTHONPATH
else
  export PYTHONPATH=$GHIDRA_HOME/Ghidra/Debug/Debugger-agent-gdb/pypkg/src:$PYTHONPATH
  export PYTHONPATH=$GHIDRA_HOME/Ghidra/Debug/Debugger-rmi-trace/pypkg/src:$PYTHONPATH
fi

target_image="$1"

# No need to put QEMU_GDB on command line. It's already a recognized environment variable.
if [ -z "$TTY_TARGET" ]
then
  "$GHIDRA_LANG_EXTTOOL_qemu" $OPT_EXTRA_QEMU_ARGS $@ &
else
  "$GHIDRA_LANG_EXTTOOL_qemu" $OPT_EXTRA_QEMU_ARGS $@ <$TTY_TARGET >$TTY_TARGET 2>&1 &
fi

# Give QEMU a moment to open the socket
sleep 0.1

declare -a args

args+=(-q)
args+=(-ex "set pagination off")
args+=(-ex "set confirm off")
args+=(-ex "show version")
args+=(-ex "python import ghidragdb")
args+=(-ex "set architecture $OPT_ARCH")
args+=(-ex "set endian $OPT_ENDIAN")
args+=(-ex "file '$target_image'")
args+=(-ex "ghidra trace connect '$GHIDRA_TRACE_RMI_ADDR'")
args+=(-ex "ghidra trace start")
args+=(-ex "ghidra trace sync-enable")
args+=(-ex "target remote localhost:$QEMU_GDB")
if [ "$OPT_PULL_ALL_SECTIONS" = "true" ]
then
  args+=(-ex "ghidra trace tx-start put-all-sections")
  args+=(-ex "ghidra trace put-sections -all-objects")
  args+=(-ex "ghidra trace tx-commit")
fi
args+=(-ex "set confirm on")
args+=(-ex "set pagination on")

"$OPT_GDB_PATH" "${args[@]}"
