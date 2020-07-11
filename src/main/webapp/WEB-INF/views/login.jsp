<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login test</title>
	</head>
	<body>
		<h3>## login view ##</h3>
		<input type = "text" id = "m_id" placeholder="아이디"><br>
		<input type = "password" id = "m_pw" placeholder="비밀번호"><br>
		<button id = "login_process">login</button>
		<p><a href = "/register">join</a></p>
		
		<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
		<script>
		$(document).ready(function(){
			$("#login_process").click(function(){
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
					url : "Login",
					data : json,
					success : function(data) {
						switch (Number(data.result)) {
						case 0:
							alert("아이디 또는 비밀번호가 일치하지 않습니다.");
							break;
						case 1:
							window.location.href = "/index";

						default:
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