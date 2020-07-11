<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>board write test</title>
</head>
<body>
    <h3>## board list ##</h3>
<%--    <a href="/board_wrtie">write</a>--%>
    <div id="jsGrid"></div>
<%--    <table border="1">--%>
<%--        <thead>--%>
<%--            <tr>--%>
<%--                <th scope="col">#</th>--%>
<%--                <th scope="col">제목</th>--%>
<%--                <th scope="col">작성자</th>--%>
<%--                <th scope="col">등록일</th>--%>
<%--            </tr>--%>
<%--        </thead>--%>
<%--        <tbody id="tbody">--%>
<%--        </tbody>--%>
<%--    </table>--%>
    <div style="margin-top: 5px;" id="writeFrm">
        <input type="text" id="b_title" placeholder="title"><br>
        <input type = "text" id = "b_id" placeholder="작성자" value="${m.m_id }"><br>
        <textarea rows="5" id="b_content" placeholder="content"></textarea><br>
        <button id="wrtie_process">save</button>
        <p><a href="/">main</a></p>
    </div>
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.js"></script>
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid.min.css" />
    <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jsgrid/1.5.3/jsgrid-theme.min.css" />
    <script>
        $(document).ready(function() {

            loadlist();

            $("#wrtie_process").click(function(){

                var json = {
                    b_title : $("#b_title").val(),
                    b_content : $("#b_content").val()
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
                    url : "board_wrtie",
                    data : json,
                    success : function(data) {
                        switch (Number(data.result)) {
                            case 401:
                                alert("로그인 후 이용해주세요.");
                                window.location.href = "/";
                                break;
                            case 0:
                                alert("정상적으로 등록이 되었습니다.");
                                // window.location.href = "/board_list";
                                $("#b_title").val(null);
                                $("#b_content").val(null);
                                loadlist();
                                break;

                            default:
                                alert("알수없는 오류가 발생했습니다. [ErrorCode : " + Number(data.result) + "]");
                                break;
                        }
                    },
                    error : function(error) {
                        alert("오류 발생"+ error);
                    }
                });
            });
        });


        function loadlist() {
            $.ajax({
                type: "GET",
                url: "get_board",
                success: function(data) {
                    console.log(data);
                    // $("#tbody").html(null);
                    // for (var str in data.result) {
                    //     var tr = $("<tr></tr>").appendTo("#tbody");
                    //     $("<td></td>").text(data.result[str]['b_no']).appendTo(tr);
                    //     $("<td></td>").text(data.result[str]['b_title']).appendTo(tr);
                    //     $("<td></td>").text(data.result[str]['b_owner_nick']).appendTo(tr);
                    //     $("<td></td>").text(formatDate(data.result[str]['b_regdate'])).appendTo(tr);
                    // }

                    $("#jsGrid").jsGrid({
                        width: "100%",
                        height: "400px",
                        sorting: true, // 칼럼의 헤더를 눌렀을 때, 그 헤더를 통한 정렬
                        data: data.result, //아래에 있는 client 배열을 데이터를 받아서
                        fields: [ // 그리드 헤더 부분에 넣기 위해서 필드 지정
                            { name: "b_no", type: "text", width: 50 },
                            { name: "b_title", type: "text", width: 300 },
                            { name: "b_owner_nick", type: "text", width: 150 },
                            { name: "b_regdate", type: "text", width: 80 },
                        ]
                    });
                },
                error: function(error) {
                    alert("오류 발생" + error);
                }
            });
        }

        function formatDate(unixtime) {
            var u = new Date(unixtime);
            return u.getUTCFullYear() +
                '-' + ('0' + u.getUTCMonth()).slice(-2) +
                '-' + ('0' + u.getUTCDate()).slice(-2) +
                ' ' + ('0' + u.getUTCHours()).slice(-2) +
                ':' + ('0' + u.getUTCMinutes()).slice(-2) +
                ':' + ('0' + u.getUTCSeconds()).slice(-2)
        };

    </script>
</body>

</html>
