from email.policy import default
from .find_classrooms import find_classrooms
from collections import defaultdict
from pprint import pprint
from logging import root
import datetime
import json 

MAX_TIME = 20

def _is_room_free(lessons, starting_time, ending_time):
    until = MAX_TIME
    
    if len(lessons) == 0:
        return (True, until)

    for lesson in lessons:
        start = float(lesson['from'])
        end = float(lesson['to'])

        if starting_time <= start and start < ending_time:
            return (False, None)

        if start <= starting_time and end > starting_time:
            return (False, None)

        if ending_time <= start and until == MAX_TIME:
            until = start

    return (True, until)


def find_free_room(starting_time , ending_time , location , day , month , year, filters=None):
    """
    Find free rooms with optional filters.

    Args:
        filters (dict): Optional filters with keys:
            - 'power_plugs' (bool): If True, only return rooms with power plugs
            - 'min_duration' (int): Minimum hours the room should be free
    """
    if filters is None:
        filters = {'power_plugs': False, 'min_duration': None}

    free_rooms = defaultdict(list)
    infos = find_classrooms(location , day , month , year)

    for building in infos:
        for room in infos[building]:
            lessons = infos[building][room]['lessons']
            free, until = _is_room_free(lessons , starting_time , ending_time)

            if free:
                # Apply power plugs filter
                if filters.get('power_plugs', False) and not infos[building][room]['powerPlugs']:
                    continue

                # Apply minimum duration filter
                if filters.get('min_duration'):
                    duration = until - starting_time
                    if duration < filters['min_duration']:
                        continue

                room_info = {
                    'name' : room ,
                    'link':infos[building][room]['link'],
                    'until': until,
                    'powerPlugs': infos[building][room]['powerPlugs']
                }

                free_rooms[building].append(room_info)

    return free_rooms


if __name__ == "__main__":
    now = datetime.datetime.now()
    info = find_free_room(9.25 , 12.25 , 'MIA', 25 , 10 , 2021)
    with open('infos_a.json' , 'w') as outfile:
        json.dump(info , outfile)