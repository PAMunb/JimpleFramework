package lang.jimple.util;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Pair<First, Second> {
	
	First first; 
	Second second; 

}
