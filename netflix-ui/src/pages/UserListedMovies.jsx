import axios from "axios";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Card from "../components/Card";
import styled from "styled-components";
import Navbar from "../components/Navbar";
import { getUsersLikedMovies } from "../store";
import { useDispatch, useSelector } from "react-redux";

export default function UserListedMovies() {
  const movies = useSelector((state) => state.netflix.movies);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const [isScrolled, setIsScrolled] = useState(false);
  const [datas, setData] = useState(undefined);
  const [typeEvaluation, setTypeEvaluation] = useState('neutral');

  useEffect( () => {
    function userSignIn(){
      const data = JSON.parse(localStorage.getItem('user'))
      if(data) setData(data);
      else navigate("/login");
    }

    userSignIn()
  }, [navigate])


  useEffect(() => {
    if (datas) {
      dispatch(getUsersLikedMovies(datas));
    }
  }, [datas]);

  window.onscroll = () => {
    setIsScrolled(window.pageYOffset === 0 ? false : true);
    return () => (window.onscroll = null);
  };

  return (
    <Container>
      <Navbar isScrolled={isScrolled} />
      <div className="content flex column">
        <h1>My List</h1>
        <Select
          className="flex"
          onChange={(e) => {
            setTypeEvaluation(e.target.value)
          }}
        >
          {['neutral', 'like', 'dislike'].map((genre, index) => {
            return (
              <option value={genre} key={index}>
                {genre}
              </option>
            );
          })}
        </Select>
        <div className="grid flex">
          {movies.filter(data => data.evaluation === typeEvaluation).map((data, index) => {
            return (
              <Card
                movieData={data.movie}
                index={index}
                key={data.movie.id}
                isWished={data.wished}
                Evaluation={data.evaluation}
              />
            );
          })}
        </div>
      </div>
    </Container>
  );
}

const Container = styled.div`
  .content {
    margin: 2.3rem;
    margin-top: 8rem;
    gap: 3rem;
    h1 {
      margin-left: 3rem;
    }
    .grid {
      flex-wrap: wrap;
      gap: 1rem;
    }
  }
`;

const Select = styled.select`
  margin-left: 5rem;
  cursor: pointer;
  font-size: 1.4rem;
  background-color: rgba(0, 0, 0, 0.4);
  color: white;
`;
