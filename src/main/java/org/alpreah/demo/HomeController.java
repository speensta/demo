package org.alpreah.demo;

import org.alpreah.annotation.AuthArgument;
import org.alpreah.domain.board;
import org.alpreah.domain.member;
import org.alpreah.domain.memberArgument;
import org.alpreah.persistence.board_dao;
import org.alpreah.persistence.member_dao;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.print.DocFlavor;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {
	
	@Inject
	private member_dao m_dao;
	
	@Inject
	private board_dao b_dao;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String login() {
		return "login";
	}
	
	@ResponseBody
	@RequestMapping(value = "Login", method = RequestMethod.POST)
	public Map login(member m, HttpSession session) {
		Map<String, String> map = new HashMap<>();
		int result = m_dao.Login(m, session);
		map.put("result", String.valueOf(result));
		return map;
	}
	
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String register() {
		return "register";
	}
	
	@ResponseBody
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public Map register(member m) {
		Map<String, String> map = new HashMap<>();
		int result = m_dao.Register(m);
		map.put("result", String.valueOf(result));
		return map;
	}
	
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(@AuthArgument memberArgument member) {
		System.out.println(member.getM().getM_id());
		System.out.println(member.getIp());
		return "index";
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		session.removeAttribute("m");
		return "redirect:/";
	}
	
	@RequestMapping(value = "/board_wrtie", method = RequestMethod.GET)
	public ModelAndView board_wrtie(@AuthArgument memberArgument member) {
		ModelAndView mv = new ModelAndView("/board_wrtie");
		mv.addObject("m", member.getM());

		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/board_wrtie", method = RequestMethod.POST)
	public Map board_wrtie(@AuthArgument memberArgument member, board b) {
		Map<String, String> map = new HashMap<>();
		member m = member.getM();
		if(m == null) {
			map.put("result", String.valueOf("401"));
			return map;
		}
		b.setB_owner(m.getM_no());
		int result = b_dao.board_write(b);
		map.put("result", String.valueOf(result));
		return map;
	}
	
	@RequestMapping(value = "/board_list", method = RequestMethod.GET)
	public ModelAndView board_list(@AuthArgument memberArgument member) {
		ModelAndView mv = new ModelAndView("/board_list");
		mv.addObject("m", member.getM());

		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/get_board", method = RequestMethod.GET)
	public Map get_board() {
		Map<String, List<board>> map = new HashMap<>();
		map.put("result", b_dao.get_board());
		return map;
	}


	@ResponseBody
	@RequestMapping(value = "/v1/signin", method = RequestMethod.POST)
	public Map loginApi(member m, HttpSession session) {
		Map<String, String> map = new HashMap<>();
		int result = m_dao.Login(m, session);
		if(result > 0) {
			map.put("success", "true");
			map.put("code", String.valueOf(1));
			map.put("mgs", "성공하였습니다.");
		} else {
			map.put("success", "false");
			map.put("code", String.valueOf(-1001));
			map.put("mgs", "계정이 존재하지 않거나 이메일 또는 비밀번호가 정확하지 않습니다.");
		}

		map.put("success", "true");
		map.put("code", String.valueOf(1));
		map.put("mgs", "성공하였습니다.");
		return map;
	}

//	@ControllerAdvice
//	public class JsonpAdviceController extends AbstractJsonpResponseBodyAdvice {
//		public JsonpAdviceController() {
//			super("callback");
//		}
//	}
//
//	@Bean
//	public MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter() {
//		MappingJackson2HttpMessageConverter jsonConverter = new MappingJackson2HttpMessageConverter();
//		ObjectMapper objectMapper = new ObjectMapper();
//		objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
//		jsonConverter.setObjectMapper(objectMapper);
//		return jsonConverter;
//	}

}
