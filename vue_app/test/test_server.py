"""
测试与web app的接口
"""

from flask import Flask, jsonify, request

app = Flask(__name__)


def return_rsp(data=None, code=0, msg=''):
    if not data:
        data = {}
    rsp = {
        'code': code,
        'data': data,
        'msg': msg
    }

    return jsonify(rsp)


@app.route('/login', methods=['POST'])
def user_login():
    rsp = {}
    return return_rsp(rsp)


@app.route('/api/login_info', methods=['POST', 'GET'])
def loginfo():
    rsp = [
        {
            'login_user': 'wanligui',
            'request_headers': '',
            'client_addr': '127.0.0.1',
            'client_port': 12345,
            'request_uri': '',
            'insert_time': 1660381432
        }
    ]
    # for item in dir(request):
    #     print(item)

    print('recv req, remote addr:{}, data:{}, host url:{}, host:{}, path:{}, query:{}, url:{}'.format(
        request.remote_addr,
        request.data,
        request.host_url,
        request.host,
        request.path,
        request.query_string,
        request.url,
    ))

    return return_rsp(rsp)


def main():
    app.run(
        host='0.0.0.0',
        port=12345
    )


if __name__ == '__main__':
    main()
