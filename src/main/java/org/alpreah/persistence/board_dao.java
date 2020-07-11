package org.alpreah.persistence;

import java.util.List;

import javax.inject.Inject;

import org.alpreah.domain.board;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class board_dao {
	@Inject
	private SqlSession session;
	private static final String NameSpace = "boardMapper.";
	
	public int board_write(board b) {
		try {
			//로그인 세션의 정보가 없으면 -1로 리턴
			if(b.getB_owner() == 0) {
				return -1;
			}
			
			//DB 값 삽입
			session.insert(NameSpace + "Insert_board", b);
			//성공시 0 으로 리턴
			return 0;
		}
		catch (Exception e) {
			//오류 로그 출력
			e.printStackTrace();
			//오류 발생시 1로 리턴
			return 1;
		}
	}
	
	public List<board> get_board(){
		//시도
		try {
			//리스트로 받은 게시글을 리턴
			return session.selectList(NameSpace + "get_board");
		}
		catch (Exception e) {
			//오류 로그 출력
			e.printStackTrace();
			//오류시 널 출력
			return null;
		}
	}
}
