package org.alpreah.domain;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Auth {
    private String m_group;
    private String m_ip;
    private String m_id;
}
