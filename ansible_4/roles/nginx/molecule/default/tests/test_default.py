def test_mongo_running_and_enabled(host):
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled
def test_config_file(File):
    config_file = File('/etc/mongod.conf')
    assert config_file.is_file
    assert config_file.contains('bindIp: 0.0.0.0')
def test_socket_listening(Socket):
    socket = Socket('tcp://0.0.0.0:27017')
    assert socket.is_listening
