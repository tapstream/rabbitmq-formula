{% for name, plugin in salt["pillar.get"]("rabbitmq:plugin", {}).items() %}
{{ name }}:
  rabbitmq_plugin:
    {% for value in plugin %}
    - {{ value }}
    {% endfor %}
    - runas: root
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_plugins
    - watch_in:
      - service: rabbitmq-server
{% endfor %}

rabbitmq_plugins_permissions:
  file.managed:
    - name: /etc/rabbitmq/enabled_plugins
    - user: root
    - group: root
    - mode: 644

{% for name, policy in salt["pillar.get"]("rabbitmq:policy", {}).items() %}
{{ name }}:
  rabbitmq_policy.present:
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

# need to create users and then vhosts

{% for name, user in salt["pillar.get"]("rabbitmq:user", {}).items() %}
rabbitmq_user_{{ name }}:
  rabbitmq_user.present:
    - name: {{ name }}
    {% for value in user %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:vhost", {}).items() %}
rabbitmq_vhost_{{ name }}:
  rabbitmq_vhost.present:
    - name: {{ name }}
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}
