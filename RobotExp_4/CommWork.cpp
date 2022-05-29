
#include "stdafx.h"
#include "DataType.h"
#include "CommWork.h"
#include "SystemMemory.h"
#include <iostream>

CCommWork::CCommWork(std::string name)
	:CWorkBase(name)
{
	memset(&_target, 0, sizeof(ControlData_t));
	memset(&_current, 0, sizeof(ControlData_t));

	_memname_tar = name + "_Controller_Target";
	_memname_cur = name + "_Controller_Current";

	CREATE_SYSTEM_MEMORY(_memname_tar, ControlData_t);
	CREATE_SYSTEM_MEMORY(_memname_cur, ControlData_t);

	// packet의 header , idm mode, size init 다만 id 사용안함
	_sendPacket.data.header[0] = _sendPacket.data.header[1] = _sendPacket.data.header[2] = _sendPacket.data.header[3] = 0xFE;
	_sendPacket.data.id = 1;
	_sendPacket.data.mode = 2;
	_sendPacket.data.size = sizeof(Packet_t);

}


CCommWork::~CCommWork() {

	DELETE_SYSTEM_MEMORY(_memname_tar);
	DELETE_SYSTEM_MEMORY(_memname_cur);

	ClosePort();
}



bool CCommWork::OpenPort(std::string name, int baudRate) {

	return _comm.Open(name.c_str(), baudRate);
}



void CCommWork::ClosePort() {

	_comm.Close();
}



void CCommWork::_execute() {

	GET_SYSTEM_MEMORY(_memname_tar, _target);

    static int mode, readSize = 0, checkSize;
    static unsigned char check;

    if (_comm.isOpen()) {

        _sendPacket.data.check = 0;
		if (abs(_target.position) >= (360. * 0.0174533)) _target.position = fmod(_target.position, (360. * 0.0174533));
        _sendPacket.data.pos = _target.position * 1000;
        _sendPacket.data.velo = _target.velocity * 1000; 
        _sendPacket.data.cur = _target.current * 1000;		// 받았을 때 1000을 나눠서 받았으므로, 다시 1000을 곱해준다. 

		// printf("%d %d %d\n", _target.position * 1000, _target.velocity * 1000, _target.current * 1000);
		 //printf("%d %d %d  \n", _sendPacket.data.pos, _sendPacket.data.velo,  _sendPacket.data.cur);

        //checkbit 제작
        for (int i = 8; i < sizeof(Packet_t); i++)
            _sendPacket.data.check += _sendPacket.buffer[i];
        //packet 발송
        _comm.Write((char*)_sendPacket.buffer, sizeof(Packet_t));



        //receive packet: ATMega128에서 받은 패킷 데이터 분해
        readSize = _comm.Read((char*)_recvBuf, 4096);

        for (int i = 0; i < readSize; i++) {
			// printf("%d\n", mode);
            switch (mode) {

            case 0:
                if (_recvBuf[i] == 0xFE) {//시작패킷 4번 들어오는지 확인후 mode1로 변경
                    checkSize++;
                    if (checkSize == 4) {
                        mode = 1;
                    }
                }
                else {
                    checkSize = 0;
                }
                break;

            case 1:
                //패킷 받은거 buffer에 저장
                _packet.buffer[checkSize++] = _recvBuf[i];
                //8bit전송받았는지 확인하고 mode2번으로 변경
                if (checkSize == 8) {
                    mode = 2;
                }
                break;

            case 2:
                //패킷 pos,vel,cur값 받은거 저장
                _packet.buffer[checkSize++] = _recvBuf[i];
                check += _recvBuf[i];   // check sum

                if (checkSize == _packet.data.size) {
                    if (check == _packet.data.check) {         // check bit 확인
                      
                        _current.position = _packet.data.pos / 1000.;      //get Motor Pos
                        _current.velocity = _packet.data.velo / 1000.;      //get Motor Vel
                        _current.current = _packet.data.cur / 1000.;      //get Motor Cur
                        ControlData_t motor_data;

                        motor_data.position = _current.position;
                        motor_data.velocity = _current.velocity;
                        motor_data.current = _current.current;
                        SET_SYSTEM_MEMORY("graph", motor_data);

                        printf("%lf\n", motor_data.position * RAD2DEG);
                        //printf("%lf\n", _current.current);
						/*
						printf("pos : %lf, velo : %lf, cur : %lf\n",
							_current.position,
							_current.velocity,
							_current.current);
						*/
                    }
                    //memset(_recvBuf, 0, readSize);

                    // 초기화
                    check = 0;
                    mode = 0;
                    checkSize = 0;

                }

            }
        }
    }
        SET_SYSTEM_MEMORY(_memname_cur, _current);
					// 이렇게 저장한 다음, [RobotExp_4Dlg.cpp]의 OnTimer 함수에서 불러온다 
					// 그리고 editCur에 현재 값으로 출력이 된다.
}