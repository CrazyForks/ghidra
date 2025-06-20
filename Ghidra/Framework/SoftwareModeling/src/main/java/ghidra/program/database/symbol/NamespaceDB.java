/* ###
 * IP: GHIDRA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ghidra.program.database.symbol;

import ghidra.program.model.address.AddressSetView;
import ghidra.program.model.listing.CircularDependencyException;
import ghidra.program.model.symbol.Namespace;
import ghidra.program.model.symbol.Symbol;
import ghidra.util.exception.DuplicateNameException;
import ghidra.util.exception.InvalidInputException;

/**
 * Class to represent a set of related symbols. Symbols within a namespace must have 
 * unique names.
 */

class NamespaceDB implements Namespace {
	private NamespaceSymbol symbol;
	private NamespaceManager namespaceMgr;

	/**
	 * Construct a new NamespaceDB
	 * @param symbol the symbol associated with this namespace.
	 * @param namespaceMgr the namespace manager
	 */
	NamespaceDB(NamespaceSymbol symbol, NamespaceManager namespaceMgr) {
		this.symbol = symbol;
		this.namespaceMgr = namespaceMgr;
	}

	@Override
	public Symbol getSymbol() {
		return symbol;
	}

	@Override
	public String getName() {
		return symbol.getName();
	}

	@Override
	public long getID() {
		return symbol.getID();
	}

	@Override
	public Namespace getParentNamespace() {
		return symbol.getParentNamespace();
	}

	@Override
	public AddressSetView getBody() {
		return namespaceMgr.getAddressSet(this);
	}

	@Override
	public String getName(boolean includeNamespacePath) {
		return symbol.getName(includeNamespacePath);
	}

	@Override
	public int hashCode() {
		return symbol.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		if (obj.getClass() != getClass()) {
			return false;
		}
		NamespaceDB nameSpace = (NamespaceDB) obj;

		return symbol == nameSpace.symbol;
	}

	@Override
	public void setParentNamespace(Namespace parentNamespace)
			throws DuplicateNameException, InvalidInputException, CircularDependencyException {
		symbol.setNamespace(parentNamespace);
	}

	@Override
	public String toString() {
		return getName(true);
	}

	@Override
	public boolean isExternal() {
		return symbol.isExternal();
	}

}
