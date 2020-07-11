package org.alpreah.domain;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class memberArgument {
	private member m;
	private String ip;
	private int count;
}
