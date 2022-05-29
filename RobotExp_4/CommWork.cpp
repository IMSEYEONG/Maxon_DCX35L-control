
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

	// packet�� header , idm mode, size init �ٸ� id ������
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
        _sendPacket.data.cur = _target.current * 1000;		// �޾��� �� 1000�� ������ �޾����Ƿ�, �ٽ� 1000�� �����ش�. 

		// printf("%d %d %d\n", _target.position * 1000, _target.velocity * 1000, _target.current * 1000);
		 //printf("%d %d %d  \n", _sendPacket.data.pos, _sendPacket.data.velo,  _sendPacket.data.cur);

        //checkbit ����
        for (int i = 8; i < sizeof(Packet_t); i++)
            _sendPacket.data.check += _sendPacket.buffer[i];
        //packet �߼�
        _comm.Write((char*)_sendPacket.buffer, sizeof(Packet_t));



        //receive packet: ATMega128���� ���� ��Ŷ ������ ����
        readSize = _comm.Read((char*)_recvBuf, 4096);

        for (int i = 0; i < readSize; i++) {
			// printf("%d\n", mode);
            switch (mode) {

            case 0:
                if (_recvBuf[i] == 0xFE) {//������Ŷ 4�� �������� Ȯ���� mode1�� ����
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
                //��Ŷ ������ buffer�� ����
                _packet.buffer[checkSize++] = _recvBuf[i];
                //8bit���۹޾Ҵ��� Ȯ���ϰ� mode2������ ����
                if (checkSize == 8) {
                    mode = 2;
                }
                break;

            case 2:
                //��Ŷ pos,vel,cur�� ������ ����
                _packet.buffer[checkSize++] = _recvBuf[i];
                check += _recvBuf[i];   // check sum

                if (checkSize == _packet.data.size) {
                    if (check == _packet.data.check) {         // check bit Ȯ��
                      
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

                    // �ʱ�ȭ
                    check = 0;
                    mode = 0;
                    checkSize = 0;

                }

            }
        }
    }
        SET_SYSTEM_MEMORY(_memname_cur, _current);
					// �̷��� ������ ����, [RobotExp_4Dlg.cpp]�� OnTimer �Լ����� �ҷ��´� 
					// �׸��� editCur�� ���� ������ ����� �ȴ�.
}