<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>join test</title>
	</head>
	<body>
		<h3>## join view ##</h3>
		<input type = "text" id = "m_id" placeholder="아이디"><br>
		<input type = "password" id = "m_pw" placeholder="비밀번호"><br>
		<button id = "register_process">회원가입</button>
		<p><a href = "/register">회원가입</a></p>
		
		<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
		<script>
			$(document).ready(function(){
				$("#register_process").click(function(){
					var json = {
						m_id : $("#m_id").val(),
						m_pw : $("#m_pw").val()
					};
					
					for(var str in json){
						if(json[str].length == 0){
							alert($("#" + str).attr("placeholder") + "를 입력해주세요.");
							$("#" + str).focus();
							return;
						}
					}
					
					 $.ajax({
						type : "post",
						url : "register",
						data : json,
						success : function(data) {
							switch (Number(data.result)) {
							case 0:
								alert("정상적으로 회원가입 되었습니다.");
								window.location.href = "/";
								break;
							case 1:
								alert("아이디가 중복 되었습니다.");
								break;
							default:
								alert("알수없는 오류가 발생 했습니다. [Error Code :" + Number(data.result) + "]");
								break;
							}
						},
						error : function(error) {
							alert("오류 발생"+ error);
						}
					});
				});
			});
		</script>
	</body>
</html>