package org.alpreah.domain;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class board {
	private int b_no;
	private int b_owner;
	private String b_owner_nick;
	private String b_title;
	private String b_content;
	private Timestamp b_regdate;
	private String authCode;

}
