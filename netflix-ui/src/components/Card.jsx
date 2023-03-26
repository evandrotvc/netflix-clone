import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import styled from "styled-components";
import { IoPlayCircleSharp } from "react-icons/io5";
import { AiOutlinePlus } from "react-icons/ai";
import { RiThumbUpFill, RiThumbDownFill } from "react-icons/ri";
import { BiChevronDown } from "react-icons/bi";
import { BsCheck } from "react-icons/bs";
import axios from "axios";
import { useDispatch } from "react-redux";
import { removeMovieFromLiked } from "../store";
import video from "../assets/video.mp4";
import { toast } from 'react-toastify'


export default React.memo(function Card({ index, movieData, isWished = false, Evaluation = 'neutral' }) {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const [isHovered, setIsHovered] = useState(false);
  const [email, setEmail] = useState(undefined);

  const addToList = async (movie) => {
    try {
      const data = JSON.parse(localStorage.getItem('user'))

      const dto = {
        movie: {
          movie_id: movie.id,
          name: movie.name,
          genres:processingGenres(movie.genres).join(),
          image: movie.image
        }
      }

      await axios.post(`http://localhost:3001/users/${data.user_id}/add_wish`, dto, {
        headers: {
          "Content-Type": "application/json",
          'Authorization': `Bearer ${data.token}`,
          'Accept': "application/json",
        },
      });

      toast.success("Movie added in your list!");
    } catch (error) {
      const { response } = error;
      if(response.status === 401){
        localStorage.removeItem('user')
        toast.error('Token expired. Sign in in application.')
        window.location.href = '/login'
        return
      }

      toast.error('Movie already was in your list.')
    }
  };

  const evaluation_user = async (movie, evaluation) => {
    try {
      const data = JSON.parse(localStorage.getItem('user'))

      const dto = {
        movie: {
          movie_id: movie.id,
          name: movie.name,
          genres: processingGenres(movie.genres).join(),
          image: movie.image
        },
        evaluation: evaluation
      }

      await axios.post(`http://localhost:3001/users/${data.user_id}/evaluation`, dto, {
        headers: {
          "Content-Type": "application/json",
          'Authorization': `Bearer ${data.token}`,
          'Accept': "application/json",
        },
      });

      toast.success(`Movie ${evaluation} with sucess!`);
    } catch (error) {
      toast.error('Movie already was in your list.')
      console.log(error);
    }
  };

  const processingGenres = (genres) => {
    if (genres === undefined) return []
    if (typeof genres == 'string'){
      return genres.split(',')
    }

    return genres
  }

  return (
    <Container
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img
        src={`https://image.tmdb.org/t/p/w500${movieData.image}`}
        alt="card"
        onClick={() => navigate("/player")}
      />

      {isHovered && (
        <div className="hover">
          <div className="image-video-container">
            <img
              src={`https://image.tmdb.org/t/p/w500${movieData.image}`}
              alt="card"
              onClick={() => navigate("/player")}
            />
            <video
              src={video}
              autoPlay={true}
              muted
              onClick={() => navigate("/player")}
            />
          </div>
          <div className="info-container flex column">
            <h3 className="name" onClick={() => navigate("/player")}>
              {movieData.name}
            </h3>
            <div className="icons flex j-between">
              <div className="controls flex">
                <IoPlayCircleSharp
                  title="Play"
                  onClick={() => navigate("/player")}
                />
                <RiThumbUpFill title="Like" onClick={() => evaluation_user(movieData, 'like') } color={Evaluation === 'like' ? 'green' : ''} />
                <RiThumbDownFill title="Dislike" onClick={() => evaluation_user(movieData, 'dislike') } color={Evaluation === 'dislike' ? 'green' : ''}/>
                {isWished ? (
                  <BsCheck
                    title="Remove from List"
                    onClick={() =>
                      dispatch(
                        removeMovieFromLiked({ movieId: movieData.id, email })
                      )
                    }
                  />
                ) : (
                  <AiOutlinePlus title="Add to my list" onClick={ () => addToList(movieData)} />
                )}
              </div>
              <div className="info">
                <BiChevronDown title="More Info" />
              </div>
            </div>
            <div className="genres flex">
              <ul className="flex">
                {processingGenres(movieData.genres).map((genre, index) => (
                  <li key={index}>{genre}</li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      )}
    </Container>
  );
});

const Container = styled.div`
  max-width: 230px;
  width: 230px;
  height: 100%;
  cursor: pointer;
  position: relative;
  img {
    border-radius: 0.2rem;
    width: 100%;
    height: 100%;
    z-index: 10;
  }
  .hover {
    z-index: 99;
    height: max-content;
    width: 20rem;
    position: absolute;
    top: -18vh;
    left: 0;
    border-radius: 0.3rem;
    box-shadow: rgba(0, 0, 0, 0.75) 0px 3px 10px;
    background-color: #181818;
    transition: 0.3s ease-in-out;
    .image-video-container {
      position: relative;
      height: 140px;
      img {
        width: 100%;
        height: 140px;
        object-fit: cover;
        border-radius: 0.3rem;
        top: 0;
        z-index: 4;
        position: absolute;
      }
      video {
        width: 100%;
        height: 140px;
        object-fit: cover;
        border-radius: 0.3rem;
        top: 0;
        z-index: 5;
        position: absolute;
      }
    }
    .info-container {
      padding: 1rem;
      gap: 0.5rem;
    }
    .icons {
      .controls {
        display: flex;
        gap: 1rem;
      }
      svg {
        font-size: 2rem;
        cursor: pointer;
        transition: 0.3s ease-in-out;
        &:hover {
          color: #b8b8b8;
        }
      }
    }
    .genres {
      ul {
        gap: 1rem;
        li {
          padding-right: 0.7rem;
          &:first-of-type {
            list-style-type: none;
          }
        }
      }
    }
  }
`;
