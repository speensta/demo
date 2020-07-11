package org.alpreah.resorver;

import org.alpreah.annotation.AuthArgument;
import org.alpreah.domain.member;
import org.alpreah.domain.memberArgument;
import org.alpreah.persistence.member_dao;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

public class AuthArgumentResolver implements HandlerMethodArgumentResolver   {

    @Inject
    private member_dao m_dao;

    /**
     * resolveArgument를 실행 할 수 있는 method인지 판별
     * @param methodParameter
     * @return
     */
    @Override
    public boolean supportsParameter(MethodParameter methodParameter) {
        /* 어노테이션이 붙은 파라미터에 대해 적용 */
        return methodParameter.hasParameterAnnotation(AuthArgument.class);
    }

    /**
     * Method parameter에 대한 Argument Resovler로직 처리
     * @param methodParameter
     * @param modelAndViewContainer
     * @param nativeWebRequest
     * @param webDataBinderFactory
     * @return
     * @throws Exception
     */
    @Override
    public Object resolveArgument(MethodParameter methodParameter, ModelAndViewContainer modelAndViewContainer,
                                  NativeWebRequest nativeWebRequest, WebDataBinderFactory webDataBinderFactory) throws Exception {

        HttpServletRequest request = (HttpServletRequest) nativeWebRequest.getNativeRequest();
        String clientIp = request.getHeader("X-Forwarded-For");
        memberArgument mber = memberArgument.builder().m((member) nativeWebRequest.getAttribute("m", nativeWebRequest.SCOPE_SESSION))
        .ip(clientIp).build();

        int count = m_dao.Id_Check(mber.getM());
        mber.setCount(count);

        return mber;
    }
}
