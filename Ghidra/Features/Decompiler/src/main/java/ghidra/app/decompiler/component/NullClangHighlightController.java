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
package ghidra.app.decompiler.component;

import java.awt.Color;
import java.util.Set;

import docking.widgets.EventTrigger;
import docking.widgets.fieldpanel.field.Field;
import docking.widgets.fieldpanel.support.FieldLocation;
import ghidra.app.decompiler.ClangNode;
import ghidra.app.decompiler.ClangSyntaxToken;
import ghidra.program.model.pcode.PcodeOp;

/**
 * A stub implementation of the highlight controller that allows clients to avoid null checks
 */
public class NullClangHighlightController extends ClangHighlightController {

	@Override
	public void fieldLocationChanged(FieldLocation location, Field field, EventTrigger trigger) {
		// stub
	}

	@Override
	public void addPrimaryHighlights(ClangNode parentNode, ColorProvider colorProvider) {
		// stub
	}

	@Override
	public void addPrimaryHighlights(ClangNode parentNode, Set<PcodeOp> ops, Color highlightColor) {
		// stub
	}

	@Override
	public void addPrimaryHighlightToTokensForBrace(ClangSyntaxToken token, Color highlightColor) {
		// stub
	}

	@Override
	public void addListener(ClangHighlightListener listener) {
		// stub
	}

	@Override
	public void removeListener(ClangHighlightListener listener) {
		// stub
	}
}
