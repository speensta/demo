<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>board write test</title>
	</head>
	<body>
		<h3>## board write view ##</h3>

		<form method="post" name="application" id="application" enctype="multipart/form-data"
			  data-ng-app="application" data-ng-controller="application-controller" data-ng-init="init();">

			<input type = "text" id = "b_title" placeholder="게시글 제목"><br>
			<textarea rows="5" id = "b_content" placeholder="게시글 내용"></textarea><br>

		</form>

		<button id = "wrtie_process">save</button>
		<p><a href = "/board_list">list</a></p>
		<div class="app-loading-bar loading-bar" style="display: none;"></div>
		<div class="app-loading-bar loading-background" style="display: none;"></div>
		<script src="/js/angular-1.8.0/polyfill.js"></script>
		<script src="/js/angular-1.8.0/promise.min.js"></script>
		<script src="/js/angular-1.8.0/angular.min.js"></script>
		<script src="/js/angular-1.8.0/angular-loader.min.js"></script>
		<script src="/js/angular-1.8.0/angular-route.min.js"></script>
		<script src="/js/angular-1.8.0/angular-resource.min.js"></script>
		<script src="/js/angular-1.8.0/angular-animate.min.js"></script>
		<script src="/js/angular-1.8.0/angular-aria.min.js"></script>
		<script src="/js/angular-1.8.0/angular-messages.min.js"></script>
		<script src="/js/angular-1.8.0/angular-message-format.min.js"></script>
		<script src="/js/angular-1.8.0/i18n/angular-locale_ko-kr.js"></script>
		<script src="/js/angular-1.8.0/ng-file-upload-shim.min.js"></script>
		<script src="/js/angular-1.8.0/ng-file-upload.min.js"></script>
		<script>
			var appModule = angular.module('chief-application', ['ngMessages']);
			appModule.config(function ($compileProvider) {
				$compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|javascript):/);
			});
			(function (module) {
				'use strict';
				var controller = module.controller('application-controller', function ($scope) {

					$scope.telFirstPattern = /^0([0-9]{1,2})$/;
					$scope.telSecondPattern = /^([0-9]){3,4}$/;
					$scope.telThirdPattern = /^([0-9]){4}$/;

					$scope.currentFileFormCount = 1;


					$scope.init = function () {
						jQuery(".app-loading-bar").hide();
					};

					$scope.fileSelection = function (file) {
						var name = jQuery(file).val();

						var regex = /\.(TXT|DOC|PPT|XLS|HWP|PDF|JPG|JPEG|GIF|BMP|PNG|txt|doc|ppt|xls|hwp|pdf|jpg|jpeg|gif|bmp|png)$/i;
						if (regex.test(name)) {
							return;
						}

						alert("첨부할수 없는 유형의 파일입니다.");
						jQuery(file).val("");
					};

					$scope.increaseFileForm = function () {
						if ($scope.currentFileFormCount < 5) {
							$scope.currentFileFormCount++;
							var name = "file" + $scope.currentFileFormCount;

							jQuery("input[name=" + name + "]").parent().removeClass("hide");
						}
					};

					$scope.decreaseFileForm = function () {
						if ($scope.currentFileFormCount > 1) {
							$scope.currentFileFormCount--;
							var name = "file" + ($scope.currentFileFormCount + 1);

							jQuery("input[name=" + name + "]").val("");
							jQuery("input[name=" + name + "]").parent().addClass("hide");
						}
					};

					$scope.list = function () {
						jQuery("#list").submit();
					};

					$scope.reset = function () {
						$scope.tel1 = undefined;
						$scope.tel2 = undefined;
						$scope.tel3 = undefined;
						$scope.tel = undefined;
						$scope.mob1 = undefined;
						$scope.mob2 = undefined;
						$scope.mob3 = undefined;
						$scope.rstmaladr = undefined;
						$scope.qsttit = undefined;
						$scope.qstcon = undefined;
						$scope.file1 = undefined;
						$scope.file2 = undefined;
						$scope.file3 = undefined;
						$scope.file4 = undefined;
						$scope.file5 = undefined;

						jQuery("input[name=file1]").val("");
						for (var i = 0; i < 5; i++) {
							$scope.decreaseFileForm();
						}
					};

					$scope.write = function () {

						if ($scope.application.$invalid) {
							angular.forEach($scope.application.$error, function (field) {
								angular.forEach(field, function (errorField) {
									errorField.$setTouched();
								});
							});

							alert("입력 내용을 다시 확인해주시기 바랍니다.");
							return;
						}

						if (confirm("글을 등록 하시겠습니까?")) {

							jQuery(".app-loading-bar").show();

							jQuery("#application").ajaxForm({
								url: '/chief/write.do',
								enctype: 'multipart/form-data',

								type: 'POST',
								success: function (res, sta, xhr) {

									if (xhr.status == "201") {
										alert("글이 등록되었습니다.");
										jQuery("#list").submit();
									}

									jQuery(".app-loading-bar").hide();
								},
								error: function (res) {
									if (res.status == 400) {
										alert("입력 사항을 다시 확인해주시기 바랍니다.");
										return;
									}

									if (res.status == 401) {
										alert("로그인이 필요합니다.");
										if (confirm("로그인 페이지로 이동하시겠습니까?")) {
											window.location.href = "/kor/login/login.do";
										}
									}

									if (res.status == 500) {
										alert("오류가 발생되었습니다.\n\n지속적으로 해당 오류가 발견되시면,\n02-6490-6625로 연락 바랍니다.");
									}

									jQuery(".app-loading-bar").hide();
								}
							});

							jQuery("#application").submit();
						}
					};

				});

				setDirective(controller);

			})(appModule);

		</script>




		<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>
		<script>
			$(document).ready(function(){
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
								window.location.href = "/board_list";
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
		</script>
	</body>
</html>